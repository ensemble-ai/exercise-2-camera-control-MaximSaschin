class_name AutoScrollCamera
extends CameraControllerBase

@export var top_left: Vector2
@export var bottom_right: Vector2
@export var autoscroll_speed: Vector3 = Vector3(15.0, 0.0, 0.0) # Sets autoscroll speed to 15

@export var box_width: float = 24.0 # Width that best matches the visible camera width
@export var box_height: float = 13.0 # Height that best matches the visible camera height

func _ready() -> void:
	super()  
	position = target.position  
	make_current() 

func _process(delta: float) -> void:
	if !current:
		return

	global_position += Vector3(autoscroll_speed.x * delta, 0.0, autoscroll_speed.z * delta) # Autoscroll the entire frame across the map from left to right

	# Boundary checks similar to PushBox to keep target within the frame
	var tpos = target.global_position
	var cpos = global_position

	# Adjust the box dimensions to match the visible area of the camera
	var camera_width = box_width
	var camera_height = box_height

	# Boundary checks
	# Left
	var diff_between_left_edges = (tpos.x - target.WIDTH * 1.1) - (cpos.x - camera_width * 1.1)
	if diff_between_left_edges < 0:
		target.global_position.x -= diff_between_left_edges
	# Right
	var diff_between_right_edges = (tpos.x + target.WIDTH * 1.1) - (cpos.x + camera_width * 1.1)
	if diff_between_right_edges > 0:
		target.global_position.x -= diff_between_right_edges
	# Top
	var diff_between_top_edges = (tpos.z - target.HEIGHT * 1.13) - (cpos.z - camera_height * 1.13)
	if diff_between_top_edges < 0:
		target.global_position.z -= diff_between_top_edges
	# Bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT * 1.13) - (cpos.z + camera_height * 1.13)
	if diff_between_bottom_edges > 0:
		target.global_position.z -= diff_between_bottom_edges

	global_position.y = target.global_position.y + 20.0  # Keeps the camera 20 units above the vessel

	if draw_camera_logic:
		draw_logic() 

# Draw the frame
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw the frame border to match with the physical border
	var left: float = -box_width
	var right: float = box_width 
	var top: float = -box_height 
	var bottom: float = box_height 

	immediate_mesh.surface_add_vertex(Vector3(right, 0.5, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0.5, bottom))

	immediate_mesh.surface_add_vertex(Vector3(right, 0.5, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0.5, bottom))

	immediate_mesh.surface_add_vertex(Vector3(left, 0.5, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0.5, top))

	immediate_mesh.surface_add_vertex(Vector3(left, 0.5, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0.5, top))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y + 1.0, global_position.z) 

	await get_tree().process_frame
	mesh_instance.queue_free()
