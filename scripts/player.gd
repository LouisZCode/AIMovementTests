extends CharacterBody2D

@export var speed = 170.0

@onready var anim = $player_animation

func _physics_process(_delta):
	# Get mouse position and determine facing
	var mouse_pos = get_global_mouse_position()
	var facing_right = mouse_pos.x > global_position.x
	anim.flip_h = not facing_right  # Flip sprite based on mouse
	
	# Get input
	var direction = Input.get_axis("ui_left", "ui_right")
	var is_running = Input.is_action_pressed("ui_shift")
	
	# Set speed
	var current_speed = speed * 2.5 if is_running else speed
	
	# Move
	velocity.x = direction * current_speed
	move_and_slide()
	
	# Animations
	if direction != 0:
		if is_running:
			anim.play("running")
		else:
			anim.play("walking")
	else:
		anim.play("idle")
