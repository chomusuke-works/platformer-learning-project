extends CharacterBody2D

const pop_animation = preload("res://scene/PopAnimation.tscn")

signal died

enum State { IDLE, WALK, MID_AIR }

const CTRL_DELAY_MS : int = 100
const acceleration : float = 5
const deceleration : float = 7
const max_speed : float = 200
var last_direction : int = 1
var jump_time : int = -1

# Physics
const terminal_velocity : float = 400
const jump_force : int = 300

var GRAVITY : int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Controls
var state : State
var jump_release_time : int
const INPUT_DELAY_MS := int(0.01 * 1000)



func kill():
	var animation = pop_animation.instantiate()
	
	animation.position = self.position
	add_sibling.call_deferred(animation)
	
	died.emit()
	queue_free()

func get_next_state(direction: float) -> State:
	var r_state : State = state
	
	match state:
		State.IDLE:
			if direction != 0:
				r_state = State.WALK
			if !is_on_floor():
				r_state = State.MID_AIR
		State.WALK:
			if is_zero_approx(velocity.x):
				r_state = State.IDLE
			if !is_on_floor():
				r_state = State.MID_AIR
		State.MID_AIR:
			if is_on_floor():
				if velocity.x == 0:
					r_state = State.IDLE
				else:
					r_state = State.WALK
	
	return r_state



func _ready():
	add_to_group("killable")
	$Sprite.animation = "idle"
	$Sprite.play()

func _physics_process(delta: float) -> void:
	var control_direction : float = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("move_up"):
		jump_time = Time.get_ticks_msec()
	# TODO only for testing purposes
	if Input.is_action_pressed("suicide"):
		self.kill()
	
	if control_direction != 0:
		if control_direction != last_direction:
			last_direction = int(control_direction)
	
	if (state == State.WALK or state == State.IDLE) and Time.get_ticks_msec() - jump_time < CTRL_DELAY_MS:
		velocity.y = -jump_force
	
	state = get_next_state(control_direction)
	
	var a : float
	
	if control_direction != 0 and (control_direction) == sign(velocity.x) or is_zero_approx(velocity.x):
		a = acceleration
	else:
		a = deceleration
	velocity.x += max_speed * a * control_direction * delta
	velocity.x = min(max_speed, velocity.x) if velocity.x > 0 else max(-max_speed, velocity.x)
	
	velocity.y += GRAVITY * delta
	velocity.y = sign(velocity.y) * min(terminal_velocity, abs(velocity.y))
	
	move_and_slide()

func _process(_delta: float) -> void:
	$Sprite.flip_h = last_direction < 0
	
	match state:
		State.IDLE:
			$Sprite.animation = "idle"
		State.WALK:
			$Sprite.animation = "run"
		State.MID_AIR:
			$Sprite.animation = "jump" if velocity.y < 0 else "fall"
	
	# TODO: debugging
	$Label1.text = str(state)
	$Label2.text = str('(', int(velocity.x), ',', int(velocity.y), ')')
