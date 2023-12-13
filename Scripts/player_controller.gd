extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 7.5
const GRAVITY = 20.0
const MOUSE_SENSITIVITY = 0.08
const MAX_PLAYER_HP = 100

@onready var camera = $RotationHelper/Camera3D
@onready var animator = $Animator
@onready var player_mesh = $BodyHitbox/PlayerMesh
@onready var mesh_visibility_timer = $DisableClientMeshVisibility
@onready var hat = $Hat

var current_hp = MAX_PLAYER_HP

signal health_changed(health_value)

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	
	mesh_visibility_timer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("StrafeLeft", "StrafeRight", "StrafeForward", "StrafeBackward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if animator.current_animation == "shoot" or animator.current_animation == "reload_pistol":
		pass
	elif input_dir != Vector2.ZERO and is_on_floor():
		animator.play("run")
	else:
		animator.play("idle")

	move_and_slide()	
	
func _input(event):	
	if not is_multiplayer_authority(): return		
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotate_x(deg_to_rad(event.relative.y * -MOUSE_SENSITIVITY))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = camera.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		camera.rotation_degrees = camera_rot

#Hide mesh from self 
func _on_disable_mesh_visibility_timeout():
	player_mesh.visible = false
	hat.visible = false

@rpc("any_peer")
func _take_damage(damage_value):
	current_hp -= damage_value
	health_changed.emit(current_hp)
	print(current_hp)
	if current_hp <= 0:
		current_hp = MAX_PLAYER_HP
		health_changed.emit(current_hp)
		position = Vector3.ZERO
	
	
