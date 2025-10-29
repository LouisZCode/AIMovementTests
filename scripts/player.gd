extends CharacterBody2D

@export var speed = 170.0
@export var fade_distance = 165.0  # Distance to fade over (pixels, 875 - 710)
@export var fade_start_offset = 710.0  # Pixels from sprite's left edge to start fading

@onready var anim = $player_animation
@onready var arm_pivot = $ArmPivot
@onready var arm = $ArmPivot/Arm
@onready var head_pivot = $HeadPivot
@onready var head = $HeadPivot/Head
@onready var cave_foreground = get_node("../Cave_Foreground/Sprite2D")  # Reference the sprite child, not parent

var is_aiming = false

func _physics_process(_delta):
	# Aiming mode
	is_aiming = Input.is_action_pressed("ui_right_click")
	arm.visible = is_aiming
	
	# Get mouse position and determine facing
	var mouse_pos = get_global_mouse_position()
	var facing_right = mouse_pos.x > global_position.x
	anim.flip_h = not facing_right
	
	# Flip HeadPivot
	if facing_right:
		head_pivot.scale.x = 1
		head.scale.y = 1
		head_pivot.position.x = -10
		head_pivot.position.y = 145
	else:
		head_pivot.scale.x = 1
		head.scale.y = -1
		head_pivot.position.x = 5
		head_pivot.position.y = 150
	
	# Point head at mouse (gives us target angle)
	head_pivot.look_at(mouse_pos)
	var target_angle = head_pivot.rotation
	
	# Clamp rotation limits (-90 to 90 degrees)
	target_angle = clamp(target_angle, deg_to_rad(-90), deg_to_rad(90))
	
	# Apply clamped angle back to head_pivot (this makes it smooth)
	head_pivot.rotation = lerp_angle(head_pivot.rotation, target_angle, 0.15)
	
	# Rotate arm to mouse
	if is_aiming:
		arm_pivot.look_at(mouse_pos)
		# Flip arm vertically when facing left
		if facing_right:
			arm.scale.y = .25
		else:
			arm.scale.y = -.25
			arm.position.x = -10
	
	# Get input (no movement while aiming)
	var direction = 0
	if not is_aiming:
		direction = Input.get_axis("ui_left", "ui_right")
	
	# Check if moving backwards
	var is_backwards = (direction < 0 and facing_right) or (direction > 0 and not facing_right)
	
	# Only run when moving forward
	var is_running = Input.is_action_pressed("ui_shift") and not is_backwards
	var current_speed = speed * 2.5 if is_running else speed
	
	# Move
	velocity.x = direction * current_speed
	move_and_slide()
	
	# Animations
	if direction != 0:
		# Check if moving backwards (movement opposite to facing)		
		if is_backwards:
			anim.play("walking_backwards")
		elif is_running:
			anim.play("running")
		else:
			anim.play("walking")
	else:
		# Idle - choose based on aiming state
		if is_aiming:
			anim.play("idle_noarms")
		else:
			anim.play("idle")
	
	# Fade foreground when player enters the sprite
	if cave_foreground:
		# Calculate sprite's actual width and left edge
		var texture_width = cave_foreground.texture.get_width()
		var actual_width = texture_width * cave_foreground.scale.x
		var left_edge = cave_foreground.global_position.x - (actual_width / 2)

		# How far INTO the sprite from its left edge
		var distance_into_sprite = global_position.x - left_edge

		if distance_into_sprite < fade_start_offset:
			# Before fade zone - fully visible
			cave_foreground.modulate.a = 1.0
		elif distance_into_sprite < fade_start_offset + fade_distance:
			# Inside fade zone - fade proportionally
			var fade_progress = distance_into_sprite - fade_start_offset
			var alpha = 1.0 - (fade_progress / fade_distance)
			cave_foreground.modulate.a = alpha
		else:
			# Past fade zone - invisible
			cave_foreground.modulate.a = 0.0
