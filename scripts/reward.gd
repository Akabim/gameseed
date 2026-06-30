extends Control

@onready var host_bubble : Label = $HostBubble
@onready var card1 : Button = $HBox/Card1
@onready var card2 : Button = $HBox/Card2
@onready var card3 : Button = $HBox/Card3

# Daftar pilihan reward acak
var reward_pool = [
	{"type": "BOX", "amount": 2, "label": "📦 +2 Balok Lego (Chassis)"},
	{"type": "WHEEL", "amount": 2, "label": "🛞 +2 Roda Plastik (Roda)"},
	{"type": "FAN", "amount": 1, "label": "⚙️ +1 Kunci Putar (Pendorong)"},
	{"type": "BALLOON", "amount": 1, "label": "🎈 +1 Balon Foil (Pengangkat)"}
]

var chosen_options = []

func _ready():
	# Ambil 3 pilihan unik dari pool
	var pool = reward_pool.duplicate()
	pool.shuffle()
	
	chosen_options = [pool[0], pool[1], pool[2]]
	
	# Update teks kartu
	card1.text = chosen_options[0]["label"]
	card2.text = chosen_options[1]["label"]
	card3.text = chosen_options[2]["label"]
	
	# Set teks bubble dialog host
	host_bubble.text = "Selamat Nak! Acara TV kita bangga padamu.\nIni hadiah mainan untuk tantangan Peri Gigi Level %d!" % (Global.current_level + 1)
	
	# Hubungkan sinyal tombol
	card1.pressed.connect(func(): _claim_reward(0))
	card2.pressed.connect(func(): _claim_reward(1))
	card3.pressed.connect(func(): _claim_reward(2))
	
	# Setup hover animations
	for card in [card1, card2, card3]:
		card.mouse_entered.connect(func(): _on_card_hover(card))
		card.mouse_exited.connect(func(): _on_card_unhover(card))

func _claim_reward(index: int):
	var reward = chosen_options[index]
	var type = reward["type"]
	var amount = reward["amount"]
	
	# Tambahkan barang ke inventory permanen
	Global.inventory[type] += amount
	# Naikkan level
	Global.current_level += 1
	
	# Lanjut ke merakit di level berikutnya
	get_tree().change_scene_to_file("res://scenes/Build.tscn")

func _on_card_hover(btn: Button):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.1)
	tween.tween_property(btn, "theme_override_colors/font_color", Color(1, 1, 0.8), 0.1)

func _on_card_unhover(btn: Button):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property(btn, "theme_override_colors/font_color", Color(1, 1, 1), 0.1)
