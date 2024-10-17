extends TileMap

var spawn_point : Vector2

func kill_collided_object(other):
	if other.is_in_group("killable"):
		other.kill()

func _ready():
	spawn_point = $SpawnPoint.position
	$Boundaries.body_exited.connect(kill_collided_object)
