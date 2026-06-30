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
	var unlocked_announcement = ""
	
	# Cek apakah level yang diselesaikan membuka mainan baru
	if Global.current_level == 1:
		# Menyelesaikan Level 1 -> Buka Pendorong (FAN) untuk Level 2
		if not Global.unlocked_parts["FAN"]:
			Global.unlocked_parts["FAN"] = true
			Global.total_parts["FAN"] = 1 # Diberikan 1 pendorong starter gratis
			unlocked_announcement = "Luar biasa Nak! Kamu membuka item baru: ⚙️ Pendorong!\n"
			
	elif Global.current_level == 2:
		# Menyelesaikan Level 2 -> Buka Balon (BALLOON) untuk Level 3
		if not Global.unlocked_parts["BALLOON"]:
			Global.unlocked_parts["BALLOON"] = true
			Global.total_parts["BALLOON"] = 1 # Diberikan 1 balon starter gratis
			unlocked_announcement = "Hebat Nak! Kamu membuka item baru: 🎈 Balon Helium!\n"

	# Set teks bubble dialog host
	if unlocked_announcement != "":
		host_bubble.text = unlocked_announcement + "Pilih kartu bonus untuk tantangan Level %d:" % (Global.current_level + 1)
	else:
		host_bubble.text = "Bagus Nak! Acara TV kita bangga padamu.\nPilih kartu bonus untuk tantangan Level %d:" % (Global.current_level + 1)

	# Saring pool kartu acak agar hanya menawarkan item yang sudah di-unlock
	var available_pool = []
	for r in reward_pool:
		if Global.unlocked_parts[r["type"]]:
			available_pool.append(r)
			
	# Jika item yang terbuka kurang dari 3 (seperti di Level 1), kita duplicate opsi yang ada agar kartu tetap berjumlah 3
	var pool_to_draw = available_pool.duplicate()
	while pool_to_draw.size() < 3:
		pool_to_draw.append(available_pool[randi() % available_pool.size()])
		
	pool_to_draw.shuffle()
	chosen_options = [pool_to_draw[0], pool_to_draw[1], pool_to_draw[2]]
	
	# Update teks kartu
	card1.text = chosen_options[0]["label"]
	card2.text = chosen_options[1]["label"]
	card3.text = chosen_options[2]["label"]
	
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
	
	# Tambahkan barang ke total parts pool permanen
	Global.total_parts[type] += amount
	print("[Reward] Memilih reward: ", type, " +", amount)
	print("[Reward] Stok permanen baru: ", Global.total_parts)
	
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
