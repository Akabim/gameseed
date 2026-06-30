extends Node

var current_level = 1

# Status buka-kunci mainan berdasarkan progresi level
var unlocked_parts = {
	"BOX": true,
	"WHEEL": true,
	"FAN": false,
	"BALLOON": false
}

# Stok kapasitas awal Level 1 (Pendorong & Balon dikunci dulu)
var total_parts = {
	"BOX": 4,
	"WHEEL": 2,
	"FAN": 0,
	"BALLOON": 0
}

# Sisa komponen di tas yang bisa dipakai di level berjalan
var inventory = {}

func _ready():
	inventory = total_parts.duplicate()

func reset_game():
	current_level = 1
	unlocked_parts = {
		"BOX": true,
		"WHEEL": true,
		"FAN": false,
		"BALLOON": false
	}
	total_parts = {
		"BOX": 4,
		"WHEEL": 2,
		"FAN": 0,
		"BALLOON": 0
	}
	inventory = total_parts.duplicate()
