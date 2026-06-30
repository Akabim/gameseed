extends Node2D

const GRID_SIZE = 64
const BUILD_AREA_START = Vector2i(2, 2)
const BUILD_AREA_SIZE = Vector2i(8, 6)

enum PartType { EMPTY, BOX, WHEEL, FAN, BALLOON }

var grid = {} # Vector2i : PartType
var is_playing = false
var has_won = false
var has_lost = false

var stuck_timer = 0.0
var simulation_time = 0.0
var loss_countdown = 0.0
var win_countdown = 0.0
var loss_reason = ""

var is_dragging = false
var dragged_type = PartType.EMPTY
var default_font = SystemFont.new()
var build_time_left = 60.0
var tex_kardus = preload("res://assets/kardus.png")

@onready var camera : Camera2D = $Camera2D
@onready var ui_label : Label = $UI/UILabel
@onready var fairy_area : Area2D = $FairyArea
@onready var grid_drawer : Node2D = $GridDrawer

@onready var build_panel : Panel = $UI/BuildPanel
@onready var box_btn : Button = $UI/BuildPanel/HBox/BoxButton
@onready var wheel_btn : Button = $UI/BuildPanel/HBox/WheelButton
@onready var fan_btn : Button = $UI/BuildPanel/HBox/FanButton
@onready var balloon_btn : Button = $UI/BuildPanel/HBox/BalloonButton
@onready var reset_btn : Button = $UI/BuildPanel/HBox/ResetButton
@onready var play_btn : Button = $UI/BuildPanel/HBox/PlayButton

@onready var desk_node : StaticBody2D = $Desk
@onready var downhill_ramp : StaticBody2D = $DownhillRamp
@onready var launch_ramp : StaticBody2D = $LaunchRamp
@onready var floor_node : StaticBody2D = $Floor

var original_camera_pos : Vector2

var chassis_node : RigidBody2D = null
var active_fans = [] 
var active_balloons = []

func _ready():
	camera.position = Vector2(576, 324) # Paksa posisi awal kamera di tengah area build
	original_camera_pos = camera.position
	fairy_area.body_entered.connect(_on_fairy_body_entered)
	
	# Hubungkan sinyal gambar kustom ke child node GridDrawer
	grid_drawer.draw.connect(_on_grid_drawer_draw)
	
	# Hubungkan sinyal tombol UI untuk Drag & Drop
	box_btn.button_down.connect(func(): _start_drag(PartType.BOX))
	box_btn.button_up.connect(func(): _drop_item())
	
	wheel_btn.button_down.connect(func(): _start_drag(PartType.WHEEL))
	wheel_btn.button_up.connect(func(): _drop_item())
	
	fan_btn.button_down.connect(func(): _start_drag(PartType.FAN))
	fan_btn.button_up.connect(func(): _drop_item())
	
	balloon_btn.button_down.connect(func(): _start_drag(PartType.BALLOON))
	balloon_btn.button_up.connect(func(): _drop_item())
	
	# Hubungkan sinyal Reset dan Play
	reset_btn.pressed.connect(_reset_grid)
	play_btn.pressed.connect(_start_simulation)
	
	# Styling tombol Reset (merah kecokelatan) dan Play (hijau)
	var style_reset = StyleBoxFlat.new()
	style_reset.bg_color = Color(0.65, 0.25, 0.25)
	style_reset.corner_radius_top_left = 6
	style_reset.corner_radius_top_right = 6
	style_reset.corner_radius_bottom_left = 6
	style_reset.corner_radius_bottom_right = 6
	reset_btn.add_theme_stylebox_override("normal", style_reset)
	
	var style_play = StyleBoxFlat.new()
	style_play.bg_color = Color(0.2, 0.55, 0.25)
	style_play.corner_radius_top_left = 6
	style_play.corner_radius_top_right = 6
	style_play.corner_radius_bottom_left = 6
	style_play.corner_radius_bottom_right = 6
	play_btn.add_theme_stylebox_override("normal", style_play)
	
	# Posisi meja, rampa, dan Peri Gigi dibaca langsung dari scene level terkait (Level1.tscn s/d Level5.tscn) yang diedit secara visual di editor Godot.
	
	# Bersihkan grid dan isi ulang stok aktif dari total parts pool (reset untuk level baru)
	grid.clear()
	Global.inventory = Global.total_parts.duplicate()
	print("[Build] Memulai Level: ", Global.current_level)
	print("[Build] Total Parts: ", Global.total_parts)
	print("[Build] Inventory Aktif: ", Global.inventory)
	
	# Reset timer di awal
	build_time_left = 60.0
	_update_ui()

func _process(delta):
	if is_playing:
		if has_lost:
			loss_countdown -= delta
			ui_label.text = "❌ GAGAL: %s ❌\nMengulang dalam %d detik..." % [loss_reason, int(ceil(loss_countdown))]
			if loss_countdown <= 0:
				_stop_simulation()
		elif has_won:
			win_countdown -= delta
			ui_label.text = "🏆 KAMU BERHASIL NANGKEP PERI GIGI! 🏆\nPilih hadiah dalam %d detik..." % int(ceil(win_countdown))
			if win_countdown <= 0:
				# Pindah ke layar pemilihan reward (Upgrade Drafting)
				get_tree().change_scene_to_file("res://scenes/Reward.tscn")
	else:
		grid_drawer.queue_redraw() # Selalu refresh grid drawer agar mulus 60 FPS
		if is_instance_valid(fairy_area):
			var level = Global.current_level
			var t = Time.get_ticks_msec() / 1000.0
			
			match level:
				1, 2:
					# Hover naik-turun sangat lembut
					fairy_area.position.y += sin(t * 6.0) * 0.4
				3:
					# Hover sedang
					fairy_area.position.y += sin(t * 5.0) * 1.2
				4:
					# Gerakan melingkar lambat (membuat target melayang dinamis)
					fairy_area.position.y += sin(t * 3.0) * 2.0
					fairy_area.position.x += cos(t * 2.0) * 1.0
				5:
					# Gerakan zig-zag naik-turun cepat (sangat menantang!)
					fairy_area.position.y += sin(t * 8.0) * 3.5
				_:
					# Pasca-level 5: Gerakan acak cepat
					fairy_area.position.y += sin(t * 10.0) * 4.0
					fairy_area.position.x += cos(t * 5.0) * 2.0
			
		# Kurangi sisa waktu merakit jika grid tidak kosong
		if not grid.is_empty():
			build_time_left -= delta
			if build_time_left <= 0:
				_start_simulation()

func _on_fairy_body_entered(body):
	if is_playing and not has_won and not has_lost:
		if body.name == "Chassis" or body.name.begins_with("Wheel_"):
			has_won = true
			win_countdown = 4.0

func _start_drag(type: PartType):
	var type_str = _get_type_str(type)
	if Global.inventory[type_str] > 0:
		is_dragging = true
		dragged_type = type
		_update_ui()
		grid_drawer.queue_redraw()

func _drop_item():
	if not is_dragging:
		return
		
	var mouse_pos = get_global_mouse_position()
	var grid_pos = Vector2i(floor(mouse_pos.x / GRID_SIZE), floor(mouse_pos.y / GRID_SIZE))
	
	if _is_in_build_area(grid_pos) and not grid.has(grid_pos):
		var type_str = _get_type_str(dragged_type)
		if Global.inventory[type_str] > 0:
			grid[grid_pos] = dragged_type
			Global.inventory[type_str] -= 1
			
	is_dragging = false
	dragged_type = PartType.EMPTY
	_update_ui()
	grid_drawer.queue_redraw()

func _update_ui():
	if has_won:
		return
		
	if is_playing:
		ui_label.text = "== LEVEL %d (MENGEMUDI) ==\nTekan SPASI untuk nyalain Pendorong!\nBalon otomatis mengangkat ke atas.\nTekan R untuk Restart" % Global.current_level
		build_panel.visible = false
	else:
		build_panel.visible = true
		
		# Update jumlah stok sisa di teks tombol
		box_btn.text = "Kardus (%d)" % Global.inventory["BOX"]
		wheel_btn.text = "Roda (%d)" % Global.inventory["WHEEL"]
		fan_btn.text = "Pendorong (%d)" % Global.inventory["FAN"]
		balloon_btn.text = "Balon (%d)" % Global.inventory["BALLOON"]
		
		# Sembunyikan tombol barang yang belum di-unlock di level ini
		fan_btn.visible = Global.unlocked_parts["FAN"]
		balloon_btn.visible = Global.unlocked_parts["BALLOON"]
		
		var timer_text = ""
		if not grid.is_empty():
			timer_text = "\n⏰ Sisa Waktu Merakit: %d detik" % int(ceil(build_time_left))
		else:
			timer_text = "\n⏰ Siap merakit (waktu berjalan setelah part diletakkan)"
			
		ui_label.text = "== LEVEL %d (BUILD MODE) ==%s\nDRAG & DROP barang dari tombol bawah ke grid untuk merakit!\nSeret barang keluar grid untuk menghapus (atau klik kanan).\nTekan tombol LUNCURKAN! atau ENTER untuk mulai simulasi!" % [Global.current_level, timer_text]

func _get_type_str(type: PartType) -> String:
	if type == PartType.BOX: return "BOX"
	elif type == PartType.WHEEL: return "WHEEL"
	elif type == PartType.FAN: return "FAN"
	elif type == PartType.BALLOON: return "BALLOON"
	return ""

# Logika menggambar dipindahkan ke child node GridDrawer agar tampil di atas wallpaper
func _on_grid_drawer_draw():
	if not is_playing:
		# 1. Gambar batas area build
		var start_pos = Vector2(BUILD_AREA_START.x * GRID_SIZE, BUILD_AREA_START.y * GRID_SIZE)
		var size = Vector2(BUILD_AREA_SIZE.x * GRID_SIZE, BUILD_AREA_SIZE.y * GRID_SIZE)
		grid_drawer.draw_rect(Rect2(start_pos, size), Color(0.8, 0.8, 0.9, 0.3), true)
		grid_drawer.draw_rect(Rect2(start_pos, size), Color(0, 0, 1, 0.5), false, 2.0)
		
		for x in range(BUILD_AREA_START.x, BUILD_AREA_START.x + BUILD_AREA_SIZE.x + 1):
			grid_drawer.draw_line(Vector2(x * GRID_SIZE, start_pos.y), Vector2(x * GRID_SIZE, start_pos.y + size.y), Color(0,0,0,0.2))
		for y in range(BUILD_AREA_START.y, BUILD_AREA_START.y + BUILD_AREA_SIZE.y + 1):
			grid_drawer.draw_line(Vector2(start_pos.x, y * GRID_SIZE), Vector2(start_pos.x + size.x, y * GRID_SIZE), Color(0,0,0,0.2))
		
		var mouse_pos = get_global_mouse_position()
		var grid_pos = Vector2i(floor(mouse_pos.x / GRID_SIZE), floor(mouse_pos.y / GRID_SIZE))
		
		# Highlight cell yang sedang ditunjuk
		if is_dragging and _is_in_build_area(grid_pos) and not grid.has(grid_pos):
			grid_drawer.draw_rect(Rect2(grid_pos.x * GRID_SIZE, grid_pos.y * GRID_SIZE, GRID_SIZE, GRID_SIZE), Color(0, 1, 0, 0.3), true)
		elif not is_dragging and _is_in_build_area(grid_pos):
			grid_drawer.draw_rect(Rect2(grid_pos.x * GRID_SIZE, grid_pos.y * GRID_SIZE, GRID_SIZE, GRID_SIZE), Color(1, 1, 0, 0.2), true)

		# 2. Gambar parts yang ada di grid
		for pos in grid.keys():
			var type = grid[pos]
			_draw_part_on_drawer(type, Rect2(pos.x * GRID_SIZE, pos.y * GRID_SIZE, GRID_SIZE, GRID_SIZE))
			
		# 3. Gambar preview item saat sedang didrag
		if is_dragging:
			var drag_rect = Rect2(mouse_pos - Vector2(GRID_SIZE/2.0, GRID_SIZE/2.0), Vector2(GRID_SIZE, GRID_SIZE))
			_draw_part_on_drawer(dragged_type, drag_rect)

func _draw_part_on_drawer(type: PartType, rect: Rect2):
	if type == PartType.BOX:
		grid_drawer.draw_texture_rect(tex_kardus, rect, false)
	elif type == PartType.FAN:
		grid_drawer.draw_rect(rect, Color(0.2, 0.6, 0.8)) 
		grid_drawer.draw_rect(rect, Color(0.1, 0.3, 0.5), false, 2.0)
		grid_drawer.draw_line(rect.get_center(), rect.get_center() + Vector2(20, 0), Color.WHITE, 3.0)
	elif type == PartType.BALLOON:
		grid_drawer.draw_rect(rect, Color(0.8, 0.8, 0.8, 0.5)) 
		grid_drawer.draw_line(rect.get_center(), rect.get_center() - Vector2(0, 30), Color.WHITE, 2.0) 
		grid_drawer.draw_circle(rect.get_center() - Vector2(0, 30), rect.size.x/2.0 * 0.8, Color(0.9, 0.2, 0.2)) 
	elif type == PartType.WHEEL:
		grid_drawer.draw_circle(rect.get_center(), rect.size.x/2.0 * 0.9, Color(0.2, 0.2, 0.2)) 
		grid_drawer.draw_circle(rect.get_center(), rect.size.x/2.0 * 0.3, Color(0.8, 0.8, 0.8)) 

func _is_in_build_area(pos: Vector2i) -> bool:
	return pos.x >= BUILD_AREA_START.x and pos.x < BUILD_AREA_START.x + BUILD_AREA_SIZE.x and pos.y >= BUILD_AREA_START.y and pos.y < BUILD_AREA_START.y + BUILD_AREA_SIZE.y

func _input(event):
	if event is InputEventKey and event.pressed:
		if is_playing and event.keycode == KEY_R:
			_stop_simulation()
		elif not is_playing:
			if event.keycode == KEY_ENTER:
				_start_simulation()
				
	if event is InputEventMouseButton and not is_playing:
		var mouse_pos = get_global_mouse_position()
		var grid_pos = Vector2i(floor(mouse_pos.x / GRID_SIZE), floor(mouse_pos.y / GRID_SIZE))
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Seret item yang sudah ada di grid
				if _is_in_build_area(grid_pos) and grid.has(grid_pos):
					var type = grid[grid_pos]
					var type_str = _get_type_str(type)
					Global.inventory[type_str] += 1
					grid.erase(grid_pos)
					is_dragging = true
					dragged_type = type
					_update_ui()
					grid_drawer.queue_redraw()
			else:
				# Lepas klik kiri saat menyeret dari grid
				if is_dragging:
					_drop_item()
					
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			# Klik kanan hapus
			if _is_in_build_area(grid_pos) and grid.has(grid_pos):
				var type = grid[grid_pos]
				var type_str = _get_type_str(type)
				Global.inventory[type_str] += 1
				grid.erase(grid_pos)
				_update_ui()
				grid_drawer.queue_redraw()

func _physics_process(delta):
	if is_playing and is_instance_valid(chassis_node):
		simulation_time += delta
		
		var target_pos = chassis_node.to_global(chassis_node.center_of_mass)
		camera.position = camera.position.lerp(target_pos, 5.0 * delta)
		
		# Mekanik Balon (Narik terus ke atas)
		for balloon_pos in active_balloons:
			var up_force = Vector2.UP.rotated(chassis_node.rotation) * 1200.0
			var offset = balloon_pos.rotated(chassis_node.rotation)
			chassis_node.apply_force(up_force, offset)
		
		# Mekanik Kipas Angin
		if Input.is_key_pressed(KEY_SPACE):
			for fan_pos in active_fans:
				var force_dir = Vector2.RIGHT.rotated(chassis_node.rotation)
				var force_magnitude = 8000.0
				var offset = fan_pos.rotated(chassis_node.rotation)
				chassis_node.apply_force(force_dir * force_magnitude, offset)
				
		# Deteksi Kalah / Terjebak
		if not has_won and not has_lost:
			# 1. Jatuh ke jurang / jatuh ke bawah
			if chassis_node.global_position.y > 1100:
				_trigger_loss("Jatuh keluar batas!")
			# 2. Diam/Terjebak (kecepatan < 15.0 px/s setelah 2.5 detik grace period)
			elif simulation_time > 2.5:
				var speed = chassis_node.linear_velocity.length()
				if speed < 15.0:
					stuck_timer += delta
					if stuck_timer >= 3.0:
						_trigger_loss("Kendaraan terjebak!")
				else:
					stuck_timer = 0.0

func _start_simulation():
	if is_playing or grid.is_empty(): return
	is_playing = true
	has_won = false
	has_lost = false
	stuck_timer = 0.0
	simulation_time = 0.0
	loss_countdown = 3.0
	win_countdown = 4.0
	loss_reason = ""
	_update_ui()
	grid_drawer.queue_redraw() 
	
	chassis_node = RigidBody2D.new()
	chassis_node.name = "Chassis"
	chassis_node.mass = 2.0 
	add_child(chassis_node)
	
	var center_of_mass = Vector2.ZERO
	var box_count = 0
	active_fans.clear()
	active_balloons.clear()
	
	for pos in grid.keys():
		var type = grid[pos]
		var center = Vector2(pos.x * GRID_SIZE + GRID_SIZE/2.0, pos.y * GRID_SIZE + GRID_SIZE/2.0)
		
		if type in [PartType.BOX, PartType.FAN, PartType.BALLOON]:
			var col = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(GRID_SIZE, GRID_SIZE)
			col.shape = shape
			col.position = center
			chassis_node.add_child(col)
			
			if type == PartType.BOX:
				var sprite = Sprite2D.new()
				sprite.texture = tex_kardus
				sprite.position = center
				var tex_size = tex_kardus.get_size()
				sprite.scale = Vector2(float(GRID_SIZE) / tex_size.x, float(GRID_SIZE) / tex_size.y)
				chassis_node.add_child(sprite)
			elif type == PartType.FAN:
				var vis = ColorRect.new()
				vis.size = Vector2(GRID_SIZE, GRID_SIZE)
				vis.position = center - Vector2(GRID_SIZE/2.0, GRID_SIZE/2.0)
				vis.color = Color(0.2, 0.6, 0.8)
				chassis_node.add_child(vis)
				active_fans.append(center)
			elif type == PartType.BALLOON:
				var base_vis = ColorRect.new()
				base_vis.size = Vector2(GRID_SIZE, GRID_SIZE)
				base_vis.position = center - Vector2(GRID_SIZE/2.0, GRID_SIZE/2.0)
				base_vis.color = Color(0.8, 0.8, 0.8, 0.5)
				chassis_node.add_child(base_vis)
				
				var balloon_vis = Polygon2D.new()
				balloon_vis.color = Color(0.9, 0.2, 0.2)
				var b_points = PackedVector2Array()
				for i in range(16):
					var angle = i * PI * 2.0 / 16.0
					b_points.append(Vector2(cos(angle), sin(angle)) * (GRID_SIZE/2.0 * 0.8))
				balloon_vis.polygon = b_points
				balloon_vis.position = center - Vector2(0, 30)
				chassis_node.add_child(balloon_vis)
				
				active_balloons.append(center)
				
			box_count += 1
			center_of_mass += center
			
	if box_count > 0:
		chassis_node.mass = box_count * 0.5 
		chassis_node.angular_damp = 3.0 
		chassis_node.center_of_mass_mode = RigidBody2D.CENTER_OF_MASS_MODE_CUSTOM
		chassis_node.center_of_mass = center_of_mass / float(box_count)
			
	for pos in grid.keys():
		var type = grid[pos]
		var center = Vector2(pos.x * GRID_SIZE + GRID_SIZE/2.0, pos.y * GRID_SIZE + GRID_SIZE/2.0)
		
		if type == PartType.WHEEL:
			var wheel = RigidBody2D.new()
			wheel.name = "Wheel_" + str(pos.x) + "_" + str(pos.y)
			
			var mat = PhysicsMaterial.new()
			mat.friction = 1.0
			mat.rough = true
			mat.bounce = 0.3
			wheel.physics_material_override = mat
			wheel.mass = 0.5
			wheel.position = center
			add_child(wheel)
			
			var col = CollisionShape2D.new()
			var shape = CircleShape2D.new()
			shape.radius = GRID_SIZE/2.0 * 0.9
			col.shape = shape
			wheel.add_child(col)
			
			var vis = Polygon2D.new()
			vis.color = Color(0.2, 0.2, 0.2)
			var points = PackedVector2Array()
			for i in range(32):
				var angle = i * PI * 2.0 / 32.0
				points.append(Vector2(cos(angle), sin(angle)) * (GRID_SIZE/2.0 * 0.9))
			vis.polygon = points
			wheel.add_child(vis)
			
			var joint = PinJoint2D.new()
			joint.position = center
			joint.node_a = chassis_node.get_path()
			joint.node_b = wheel.get_path()
			joint.disable_collision = true 
			joint.motor_enabled = true
			joint.motor_target_velocity = 15.0 
			add_child(joint)

func _trigger_loss(reason: String):
	has_lost = true
	loss_reason = reason
	loss_countdown = 3.0

func _stop_simulation():
	if not is_playing: return
	is_playing = false
	has_won = false
	has_lost = false
	stuck_timer = 0.0
	simulation_time = 0.0
	build_time_left = 60.0
	camera.position = original_camera_pos
	_update_ui()
	
	if is_instance_valid(chassis_node):
		chassis_node.queue_free()
	
	for child in get_children():
		if child is RigidBody2D and child.name.begins_with("Wheel_"):
			child.queue_free()
		elif child is PinJoint2D:
			child.queue_free()
			
	grid_drawer.queue_redraw()

func _reset_grid():
	if is_playing:
		return
		
	for pos in grid.keys():
		var type = grid[pos]
		var type_str = _get_type_str(type)
		Global.inventory[type_str] += 1
		
	grid.clear()
	build_time_left = 60.0
	_update_ui()
	grid_drawer.queue_redraw()
