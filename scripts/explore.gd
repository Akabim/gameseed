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
	# Sebar 30 barang di lantai secara acak
	for i in range(30):
		var item = ITEM_SCENE.instantiate()
		var t = types[randi() % types.size()]
		
		# Mengatur tipe item (mengubah warna & teks berkat @tool)
		item.item_type = t
		item.position = Vector2(randf_range(-1500, 3500), 530)
		
		items_container.add_child(item)

func _process(delta):
	time_left -= delta
	if time_left <= 0:
		# Pindah ke sesi Build/Chase
		get_tree().change_scene_to_file("res://scenes/Build.tscn")
	else:
		time_label.text = "SISA WAKTU EXPLORE: " + str(int(time_left)) + " Detik\n(Ambil barang sebanyak-banyaknya buat ngerakit!)"
		inv_label.text = "=== TAS KAMU ===\nKardus: %d\nRoda: %d\nKipas: %d\nBalon: %d" % [Global.inventory["BOX"], Global.inventory["WHEEL"], Global.inventory["FAN"], Global.inventory["BALLOON"]]
