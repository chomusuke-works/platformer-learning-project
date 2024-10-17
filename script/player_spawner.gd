extends Node2D

var player_scene = preload("res://scene/player.tscn")
var spawn_point : Vector2



func spawn_player():    
	var player : CharacterBody2D = player_scene.instantiate()
	player.position = spawn_point
	
	player.died.connect($RespawnTimer.start)

	add_sibling(player)

func respawn_pending() -> bool:
	return !$RespawnTimer.is_stopped()
	
func _ready():
	$RespawnTimer.timeout.connect(spawn_player)
