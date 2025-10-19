extends CharacterBody2D

@export var speed = 200.0

@onready var anim = $player_animation

func _physics_process(_delta):
	# Get input
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Move
	velocity.x = direction * speed
	move_and_slide()
	
	# Animations
	if direction != 0:
		anim.play("walking")
		anim.flip_h = direction < 0  # Flip when moving left
	else:
		anim.play("idle")
