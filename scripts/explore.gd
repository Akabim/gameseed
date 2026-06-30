extends Node2D

const EXPLORE_TIME = 20.0 # Bikin 20 detik buat prototype, kalau 5 menit kelamaan ngetesnya
var time_left = EXPLORE_TIME

@onready var time_label : Label = $UI/TimeLabel
@onready var inv_label : Label = $UI/InventoryLabel
@onready var items_container : Node2D = $ItemsContainer

# Preload scene item agar bisa diinstansiasi secara dinamis
const ITEM_SCENE = preload("res://scenes/Item.tscn")

func _ready():
	Global.reset_inventory()
	_spawn_items()

func _spawn_items():
	var types = ["BOX", "WHEEL", "FAN", "BALLOON"]
	var spawn_points = $SpawnPoints.get_children()
	
	if spawn_points.is_empty():
		# Fallback jika tidak ada spawn points di scene
		for i in range(20):
			var item = ITEM_SCENE.instantiate()
			var t = types[randi() % types.size()]
			item.item_type = t
			item.position = Vector2(randf_range(100, 3000), 530)
			items_container.add_child(item)
		return
		
	# Mengacak urutan spawn point agar tipe barang tersebar lebih acak
	spawn_points.shuffle()
	
	for sp in spawn_points:
		var item = ITEM_SCENE.instantiate()
		var t = types[randi() % types.size()]
		
		item.item_type = t
		# Beri sedikit variasi horizontal acak agar terkesan organik
		var offset = Vector2(randf_range(-15, 15), 0)
		item.position = sp.global_position + offset
		
		items_container.add_child(item)

func _process(delta):
	time_left -= delta
	if time_left <= 0:
		# Pindah ke sesi layar transisi rangkuman terlebih dahulu
		get_tree().change_scene_to_file("res://scenes/Transition.tscn")
	else:
		time_label.text = "SISA WAKTU EXPLORE: " + str(int(time_left)) + " Detik\n(Ambil barang sebanyak-banyaknya buat ngerakit!)"
		inv_label.text = "=== TAS KAMU ===\nKardus: %d\nRoda: %d\nKipas: %d\nBalon: %d" % [Global.inventory["BOX"], Global.inventory["WHEEL"], Global.inventory["FAN"], Global.inventory["BALLOON"]]
