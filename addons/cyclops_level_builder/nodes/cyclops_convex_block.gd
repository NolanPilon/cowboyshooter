@tool
extends Node
class_name CyclopsConvexBlock

signal mesh_changed

@export var materials:Array[Material]

var control_mesh:ConvexVolume

var selected:bool = false:
	get:
		return selected
	set(value):
		if value == selected:
			return
		selected = value
		mesh_changed.emit()

var active:bool:
	get:
		return active
	set(value):
		if value == active:
			return
		active = value
		mesh_changed.emit()


var default_material:Material = preload("res://addons/cyclops_level_builder/materials/grid.tres")

@export var block_data:ConvexBlockData:
	get:
		return block_data
	set(value):
		if block_data != value:
			block_data = value
			control_mesh = ConvexVolume.new()
			control_mesh.init_from_convex_block_data(block_data)
			
			mesh_changed.emit()
	

func intersect_ray_closest(origin:Vector3, dir:Vector3)->IntersectResults:
	if !block_data:
		return null
	
	var result:IntersectResults = control_mesh.intersect_ray_closest(origin, dir)
	if result:
		result.object = self
		
	return result


func select_face(face_idx:int, select_type:Selection.Type = Selection.Type.REPLACE):
	if select_type == Selection.Type.REPLACE:
		for f in control_mesh.faces:
			f.selected = f.index == face_idx
	elif select_type == Selection.Type.ADD:
		control_mesh.faces[face_idx].selected = true
	elif select_type == Selection.Type.SUBTRACT:
		control_mesh.faces[face_idx].selected = true
	elif select_type == Selection.Type.TOGGLE:
		control_mesh.faces[face_idx].selected = !control_mesh.faces[face_idx].selected

	mesh_changed.emit()

func append_mesh(mesh:ImmediateMesh):
#	print("adding block mesh %s" % name)
	#var global_scene:CyclopsGlobalScene = get_node("/root/CyclopsAutoload")

	control_mesh.append_mesh(mesh, materials, default_material)

func append_mesh_wire(mesh:ImmediateMesh):
	var global_scene:CyclopsGlobalScene = get_node("/root/CyclopsAutoload")
	
	var mat:Material = global_scene.outline_material
	control_mesh.append_mesh_wire(mesh, mat)

func append_mesh_backfacing(mesh:ImmediateMesh):
	var global_scene:CyclopsGlobalScene = get_node("/root/CyclopsAutoload")
	
	var mat:Material = global_scene.tool_object_selected_material
	control_mesh.append_mesh_backfacing(mesh, mat)

func append_mesh_outline(mesh:ImmediateMesh, viewport_camera:Camera3D, local_to_world:Transform3D):
	var global_scene:CyclopsGlobalScene = get_node("/root/CyclopsAutoload")
	
	var mat:Material = global_scene.tool_object_active_material if active else global_scene.tool_object_selected_material
	control_mesh.append_mesh_outline(mesh, viewport_camera, local_to_world, mat)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

