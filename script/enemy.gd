extends CharacterBody2D

enum DIRECTION {LEFT, RIGHT}

@export var speed: int = 25
@export var terminal_velocity: float = 500
@export var move_at_spawntime: bool = false

var GRAVITY: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_direction: DIRECTION = DIRECTION.RIGHT

func kill_collided_object(other):
	if other.is_in_group("killable"):
		other.kill()
	
func turn_around():
	$EdgeDetector.position.x *= -1
	$WallDetector.position.x *= -1
	velocity.x *= -1
	if move_direction == DIRECTION.RIGHT:
		move_direction = DIRECTION.LEFT
	else:
		move_direction = DIRECTION.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	$KillArea.body_entered.connect(kill_collided_object)
	
	if move_at_spawntime:
		velocity.x = speed
	if (move_direction == DIRECTION.LEFT):
		velocity.x *= -1
	
	$Sprite.animation = "idle"
	$Sprite.play()


func _physics_process(delta: float):
	if !$EdgeDetector.is_colliding() or $WallDetector.is_colliding():
		self.turn_around()
	
	velocity.y = min(terminal_velocity, velocity.y + GRAVITY * delta)
	
	move_and_slide()

func _process(_delta: float):
	$Sprite.flip_h = move_direction == DIRECTION.LEFT
	
	if velocity.x == 0:
		$Sprite.animation = "idle"
	else:
		$Sprite.animation = "run"
