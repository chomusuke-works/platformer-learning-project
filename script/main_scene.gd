extends Node2D

var spawn_point : Vector2

func _ready():
	spawn_point = $Level.spawn_point
	
	$Camera.position = spawn_point
	$Camera.position.y -= ProjectSettings.get_setting("display/window/size/viewport_height") / (4 * $Camera.zoom.y)
	$PlayerSpawner.spawn_point = spawn_point
	$PlayerSpawner.spawn_player()
	
func _process(_delta : float):
	if has_node("Player"):
		$Camera.position.x = $Player.position.x
