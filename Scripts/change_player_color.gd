extends Node

@onready var player = $"."
@onready var body_mesh = $Body

func _ready():
	_change_color.rpc()

@rpc("any_peer")
func _change_color():
	if not is_multiplayer_authority():
		var active_mat = body_mesh.get_active_material(0)
		active_mat.albedo_color = Color(0.4, 0.5, 1, 0)
