@tool
extends Area2D

@export_enum("BOX", "WHEEL", "FAN", "BALLOON") var item_type: String = "BOX":
	set(val):
		item_type = val
		if is_node_ready():
			_update_visuals()

func _ready():
	_update_visuals()
	body_entered.connect(_on_body_entered)

func _update_visuals():
	var label = $Label
	var vis = $ColorRect
	if not label or not vis:
		return
		
	if item_type == "BOX":
		label.text = "Kardus"
		vis.color = Color(0.6, 0.4, 0.2)
	elif item_type == "WHEEL":
		label.text = "Roda"
		vis.color = Color(0.2, 0.2, 0.2)
	elif item_type == "FAN":
		label.text = "Kipas"
		vis.color = Color(0.2, 0.6, 0.8)
	elif item_type == "BALLOON":
		label.text = "Balon"
		vis.color = Color(0.9, 0.2, 0.2)

func _on_body_entered(body):
	if Engine.is_editor_hint():
		return
	if body.name == "Player":
		Global.inventory[item_type] += 1
		queue_free()
