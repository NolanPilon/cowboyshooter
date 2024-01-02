extends Node3D

@onready var dynamite_throw_point = $"."
@onready var player = $"../../.."

var aim : Vector3
var dynamite_ammo = 1

func _input(event):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("Throw"):
		_throw_dynamite.rpc()
		
@rpc("call_local")
func _throw_dynamite():
	if dynamite_ammo > 0:
		var dynamite = preload("res://Scenes/dynamite.tscn").instantiate()
		get_tree().get_root().add_child(dynamite)
		dynamite.position = dynamite_throw_point.global_position
		dynamite_ammo -= 1
		aim = -player.basis.z
		dynamite.apply_central_impulse(aim * 20)
	
