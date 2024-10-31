class_name PositionLockCamera
extends CameraControllerBase

func _ready() -> void:
	super()  # Call the base class _ready function
	position = target.position  # Set initial position to the target position
	make_current()  # Set this camera as the current one to ensure it works correctly
	rotation_degrees.x = -90  # Rotate the camera to look downwards

func _process(delta: float) -> void:
	if !current:
		return

	if draw_camera_logic:
		draw_logic()  # Draw the camera logic if required

	# Center the camera on the target
	global_position = target.global_position + Vector3(0.0, dist_above_target, 0.0)

func draw_logic() -> void:
	# Create a new ImmediateMesh to draw the cross
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Draw a 5x5 cross centered at the target's position
	immediate_mesh.surface_add_vertex(Vector3(-2.5, 0.5, 0))  # Slightly above the target
	immediate_mesh.surface_add_vertex(Vector3(2.5, 0.5, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0.5, -2.5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0.5, 2.5))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y + 0.5, global_position.z)  # Slightly above the target

	# Free the mesh after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
