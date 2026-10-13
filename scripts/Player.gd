extends CharacterBody2D

@export var move_speed: float = 260.0
@export var jump_velocity: float = -440.0
@export var gravity_scale: float = 1800.0
@export var max_fall_speed: float = 900.0
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12
@export var max_double_jumps: int = 1

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var extra_jumps_used: int = 0
var facing: int = 1

func _physics_process(delta: float) -> void:
	var move_input := Input.get_axis("ui_left", "ui_right")
	if move_input != 0.0:
		facing = int(sign(move_input))

	velocity.x = move_input * move_speed

	if not is_on_floor():
		velocity.y = min(velocity.y + gravity_scale * delta, max_fall_speed)
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time
		extra_jumps_used = 0

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time

	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0.0:
		if is_on_floor() or coyote_timer > 0.0:
			perform_jump()
		elif extra_jumps_used < max_double_jumps:
			extra_jumps_used += 1
			perform_jump()

	move_and_slide()
	if is_on_floor():
		coyote_timer = coyote_time

	# Keep sprite facing the direction of movement
	if facing == 1:
		$Body.scale.x = 1
	else:
		$Body.scale.x = -1

func perform_jump() -> void:
	jump_buffer_timer = 0.0
	coyote_timer = 0.0
	velocity.y = jump_velocity
