extends Node

@onready var explosion = $Explosion
@onready var timer = $RemoveMeshTimer
@onready var dynamite_mesh = $DynamiteMesh
@onready var explosion_radius = $ExplosionRadius

const EXPLOSION_DAMAGE = 75

@rpc("call_local", "any_peer")
func _explode():
	explosion.emitting = true
	explosion_radius.monitoring = true
	dynamite_mesh.visible = false
	timer.start()

func _on_timer_timeout():
	queue_free()

func _on_explosion_radius_body_entered(body):
	if body.is_in_group("player"):		
		body._take_damage(EXPLOSION_DAMAGE)
	
	if body.is_in_group("dynamite_group"):
		body._explode()
