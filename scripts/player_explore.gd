extends CharacterBody2D
var walk_sfx = preload("res://assets/audio/footstep!.ogg")
var land_sfx = preload("res://assets/audio/landing.ogg")
@export var SPEED = 400.0
@export var JUMP_VELOCITY = -450.0

# Ambil gravity default dari setting Godot
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_in_air: bool = false
var walk_timer: float = 0.0
var walk_interval: float = 0.35

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
	
	if is_on_floor() and was_in_air:
		AudioManager.play_sfx(land_sfx)
	was_in_air = not is_on_floor()
	
	if is_on_floor() and abs(velocity.x) > 10.0:
		walk_timer -= delta # Kurangi timer
		
		if walk_timer <= 0.0:
			AudioManager.play_sfx(walk_sfx)
			walk_timer = walk_interval # Reset timer ke 0.35 detik
	else:
		# Jika berhenti atau melompat, reset timer agar saat jalan lagi langsung bunyi
		walk_timer = 0.0
