extends Node3D

@onready var multiplayer_menu = $UI/FrameCounter/MultiplayerMenu
@onready var health_hud = $UI/Health
@onready var health_bar = $UI/Health/HealthBar
@onready var ammo_ui = $UI/AmmoUI
@onready var ammo_counter = $UI/AmmoUI/Ammo


const PLAYER = preload("res://Scenes/player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()


func _on_host_pressed():
	multiplayer_menu.hide()
	health_hud.show()
	ammo_ui.show()

	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(_add_player)

	_add_player(multiplayer.get_unique_id())

func _on_join_pressed():
	multiplayer_menu.hide()
	health_hud.show()
	ammo_ui.show()

	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer

func _add_player(peer_id):
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	add_child(player)
	if player.is_multiplayer_authority():
		player.health_changed.connect(_update_health_bar)
		var player_weapon = player.find_child("Revolver")
		player_weapon.ammo_changed.connect(_update_ammo_count)

func _update_health_bar(health_value):
	health_bar.value = health_value

func _update_ammo_count(ammo_value):
	ammo_counter.text = str(ammo_value) + "/6"

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.health_changed.connect(_update_health_bar)
		var node_weapon = node.find_child("Revolver")
		node_weapon.ammo_changed.connect(_update_ammo_count)

func _input(event):
	if Input.is_action_just_pressed("ToggleFullScreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


