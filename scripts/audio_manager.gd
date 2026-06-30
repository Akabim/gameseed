extends Node

var bgm_player: AudioStreamPlayer
var sfx_pool: Array[AudioStreamPlayer] = []
var pool_size: int = 10 # Jumlah maksimal suara SFX yang bisa berbunyi bersamaan

func _ready():
	# 1. Setup BGM Player
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music" # Pastikan kamu punya audio bus bernama "Music" (opsional)
	add_child(bgm_player)
	
	# 2. Setup SFX Pool
	for i in range(pool_size):
		var p = AudioStreamPlayer.new()
		p.bus = "SFX" # Audio bus khusus SFX
		add_child(p)
		sfx_pool.append(p)

# Fungsi untuk memainkan BGM
func play_bgm(stream: AudioStream):
	# Jika musik yang sama sudah bermain, jangan restart (agar mulus)
	if bgm_player.stream == stream and bgm_player.playing:
		return
		
	bgm_player.stream = stream
	bgm_player.play()

# Fungsi untuk memainkan SFX dari pool
func play_sfx(stream: AudioStream):
	for player in sfx_pool:
		if not player.playing:
			player.stream = stream
			player.play()
			return
			
	push_warning("SFX Pool penuh, suara tidak dapat diputar!")
