extends Node3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.find_child("DynamiteThrow").dynamite_ammo += 1
		queue_free()

func _process(delta):
	rotate_object_local(Vector3(0, 1, 0), 4 * delta)
