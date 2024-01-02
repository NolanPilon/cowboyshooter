extends Node3D

signal ammo_changed(ammo_value)

@onready var animator = $"../../../Animator"
@onready var fire_sound = $FireSound
@onready var shoot_ray = $"../ShootRay"
@onready var flash_timer = $MuzzleFlash/FlashTimer
@onready var muzzle_flash = $MuzzleFlash

const MAX_AMMO = 6
const REVOLER_DAMAGE = 25
var curr_ammo = 6

func _input(event):
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("Shoot") and animator.current_animation != "shoot" \
	and animator.current_animation != "reload_pistol":
		if curr_ammo == 0:
			_reload()
			return
		_play_shoot_effects.rpc()
		curr_ammo -= 1
		ammo_changed.emit(curr_ammo)
		_check_raycast()

@rpc("call_local")		
func _play_shoot_effects():
	animator.stop()
	animator.play("shoot");
	muzzle_flash.visible = true
	flash_timer.start(0.1)
	fire_sound.play()

func _check_raycast():
	if shoot_ray.is_colliding():
		var hit_target = shoot_ray.get_collider()
		
		if hit_target.name == "StaticBody3D":
			return
		
		if hit_target.name == "TargetHitbox":
			hit_target._hit_effect.rpc()
		
		if hit_target.is_in_group("player"):
			hit_target._take_damage.rpc_id(hit_target.get_multiplayer_authority(), REVOLER_DAMAGE)
			
		if hit_target.is_in_group("dynamite_group"):
			hit_target._explode.rpc()
			
func _reload():
	animator.stop()
	animator.play("reload_pistol")
	curr_ammo = MAX_AMMO
	ammo_changed.emit(curr_ammo)
	
func _on_flash_timer_timeout():
	muzzle_flash.visible = false
