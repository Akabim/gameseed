extends Node

var current_level = 1

# Total kapasitas komponen yang dimiliki pemain (permanen)
var total_parts = {
	"BOX": 4,
	"WHEEL": 2,
	"FAN": 1,
	"BALLOON": 1
}

# Sisa komponen di tas yang bisa dipakai di level berjalan (aktif)
var inventory = {}

func _ready():
	# Inisialisasi awal inventori dari total parts
	inventory = total_parts.duplicate()

func reset_game():
	current_level = 1
	total_parts = {
		"BOX": 4,
		"WHEEL": 2,
		"FAN": 1,
		"BALLOON": 1
	}
	inventory = total_parts.duplicate()
