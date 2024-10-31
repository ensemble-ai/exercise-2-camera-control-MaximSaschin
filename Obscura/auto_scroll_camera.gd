class_name FramingAutoScrollCamera
extends CameraControllerBase

@export var top_left: Vector2
@export var bottom_right: Vector2
@export var autoscroll_speed: Vector3 = Vector3(10.0, 0.0, 0.0)

@export var box_width: float = 10.0
@export var box_height: float = 10.0

func _ready() -> void:
	super()  # Call the base class _ready function
	position = target.position  # Set initial position to the target position
	make_current()  # Set this camera as the current one to ensure it works correctly

func _process(delta: float) -> void:
	if !current:
		return

	# Auto-scroll the frame
	global_position += Vector3(autoscroll_speed.x * delta, 0.0, autoscroll_speed.z * delta)

	# Apply boundary checks like PushBox logic to keep target within the frame
	var tpos = target.global_position
	var cpos = global_position

	# Adjust the box dimensions to match the visible area of the camera
	var camera_width = box_width
	var camera_height = box_height

	# Boundary checks
	# Left
	var diff_between_left_edges = (tpos.x - target.WIDTH * 2.8) - (cpos.x - camera_width * 2.8)
	if diff_between_left_edges < 0:
		target.global_position.x -= diff_between_left_edges
	# Right
	var diff_between_right_edges = (tpos.x + target.WIDTH * 2.8) - (cpos.x + camera_width * 2.8)
	if diff_between_right_edges > 0:
		target.global_position.x -= diff_between_right_edges
	# Top
	var diff_between_top_edges = (tpos.z - target.HEIGHT * 1.5) - (cpos.z - camera_height * 1.5)
	if diff_between_top_edges < 0:
		target.global_position.z -= diff_between_top_edges
	# Bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT * 1.5) - (cpos.z + camera_height * 1.5)
	if diff_between_bottom_edges > 0:
		target.global_position.z -= diff_between_bottom_edges

	# Adjust camera height to ensure it's positioned above the target
	global_position.y = target.global_position.y + 20.0  # Keep camera 20 units above the target

	if draw_camera_logic:
		draw_logic()  # Draw the camera logic if required

func draw_logic() -> void:
	# Create a new ImmediateMesh to draw the frame
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw the frame border to match the visible camera area
	var left: float = -box_width * 2.38
	var right: float = box_width * 2.38
	var top: float = -box_height * 1.3
	var bottom: float = box_height * 1.3

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
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y + 1.0, global_position.z)  # Slightly above the target

	# Free the mesh after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
