extends Node3D

@onready var spawn_pos = $SpawnPos

func _ready():
	_spawn_dynamite.rpc()

@rpc("call_local")
func _spawn_dynamite():
	var dynamite_pickup = preload("res://Scenes/Pickups/dynamite_pickup.tscn").instantiate()
	spawn_pos.add_child(dynamite_pickup)
