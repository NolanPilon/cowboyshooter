extends Control

@onready var fps_label = $FPS

func _process(delta):
	fps_label.set_text(str(Engine.get_frames_per_second()))
