extends Node3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.on_ladder = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		body.on_ladder = false
