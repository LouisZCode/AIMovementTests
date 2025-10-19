extends CharacterBody2D

@export var speed = 200.0

@onready var anim = $player_animation

func _physics_process(_delta):
	# Get input
	var direction = Input.get_axis("ui_left", "ui_right")
	var is_running = Input.is_action_pressed("ui_shift")
	
	var current_speed = speed * 2 if is_running else speed
	
	# Move
	velocity.x = direction * current_speed
	move_and_slide()
	
	# Animations
	if direction != 0:
		if is_running:
			anim.play("running")
		else:
			anim.play("walking")
		anim.flip_h = direction < 0
	else:
		anim.play("idle")
