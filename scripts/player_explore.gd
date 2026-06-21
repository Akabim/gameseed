extends CharacterBody2D

@export var SPEED = 400.0
@export var JUMP_VELOCITY = -450.0

# Ambil gravity default dari setting Godot
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Melompat (W, Space, Up, atau accept)
	if is_on_floor() and (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_SPACE) or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_accept")):
		velocity.y = JUMP_VELOCITY
	
	# WASD dan Arrow Keys
	var direction = 0.0
	if Input.is_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		direction -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		direction += 1.0
		
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
