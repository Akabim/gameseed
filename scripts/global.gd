extends Node

var current_level = 1

# Starter kit awal permainan
var inventory = {
	"BOX": 4,
	"WHEEL": 2,
	"FAN": 1,
	"BALLOON": 1
}

func reset_game():
	current_level = 1
	inventory = {
		"BOX": 4,
		"WHEEL": 2,
		"FAN": 1,
		"BALLOON": 1
	}
