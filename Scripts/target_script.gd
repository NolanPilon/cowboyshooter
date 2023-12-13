extends StaticBody3D

@onready var animation_player = $"../../AnimationPlayer"

@rpc("call_local", "any_peer")
func _hit_effect():
	animation_player.play("flip")
