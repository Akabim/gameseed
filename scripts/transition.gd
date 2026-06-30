extends Control

@onready var box_label : Label = $PaperPanel/ItemList/BoxRow
@onready var wheel_label : Label = $PaperPanel/ItemList/WheelRow
@onready var fan_label : Label = $PaperPanel/ItemList/FanRow
@onready var balloon_label : Label = $PaperPanel/ItemList/BalloonRow
@onready var start_button : Button = $PaperPanel/StartButton

func _ready():
	# Ambil data dari inventory global
	var box_count = Global.inventory.get("BOX", 0)
	var wheel_count = Global.inventory.get("WHEEL", 0)
	var fan_count = Global.inventory.get("FAN", 0)
	var balloon_count = Global.inventory.get("BALLOON", 0)
	
	# Update label teks
	box_label.text = "📦 Lego Chassis (Balok): %d" % box_count
	wheel_label.text = "🛞 Roda Plastik (Roda): %d" % wheel_count
	fan_label.text = "⚙️ Kunci Putar (Pendorong): %d" % fan_count
	balloon_label.text = "🎈 Balon Karakter (Pengangkat): %d" % balloon_count
	
	# Koneksikan signal tombol
	start_button.pressed.connect(_on_start_button_pressed)
	start_button.mouse_entered.connect(_on_button_hover)
	start_button.mouse_exited.connect(_on_button_unhover)

func _on_start_button_pressed():
	# Mainkan sound effect click jika ada (nanti bisa diintegrasikan oleh Fattah)
	get_tree().change_scene_to_file("res://scenes/Build.tscn")

func _on_button_hover():
	# Animasi scale-up sedikit pada tombol agar interaktif
	var tween = create_tween().set_parallel(true)
	tween.tween_property(start_button, "scale", Vector2(1.05, 1.05), 0.1)
	tween.tween_property(start_button, "theme_override_colors/font_color", Color(1, 1, 0.8), 0.1)

func _on_button_unhover():
	# Kembalikan ke scale normal
	var tween = create_tween().set_parallel(true)
	tween.tween_property(start_button, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property(start_button, "theme_override_colors/font_color", Color(1, 1, 1), 0.1)
