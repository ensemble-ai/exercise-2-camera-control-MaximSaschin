class_name PushZoneCamera
extends CameraControllerBase

# Standard inner and outer box sizes (width and height)
@export var box_width:float = 10.0
@export var box_height:float = 10.0
@export var inner_box_width:float = 6.0
@export var inner_box_height:float = 6.0
@export var speedup_factor:float = 0.5  # Speedup factor when inside the speedup zone

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		return

	if draw_camera_logic:
		draw_logic()

	var tpos = target.global_position
	var cpos = global_position

	# Outer boundary checks whether to push the camera
	# Left boundary (Outer box)
	var diff_between_left_edges = (tpos.x - target.WIDTH * 1.38) - (cpos.x - box_width * 1.38)
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges

	# Right boundary (Outer box)
	var diff_between_right_edges = (tpos.x + target.WIDTH * 1.38) - (cpos.x + box_width * 1.38)
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges

	# Top boundary (Outer box)
	var diff_between_top_edges = (tpos.z - target.HEIGHT * 0.7) - (cpos.z - box_height * 0.7)
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges

	# Bottom boundary (Outer box)
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT * 0.7) - (cpos.z + box_height * 0.7)
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges

	# Speedup zone logic (Area betweem the inner and outer box)
	# Adjust camera movement speed when vessel is in the speedup zone
	# Left speedup zone
	var inner_left_edge = cpos.x - inner_box_width * 1.7
	var outer_left_edge = cpos.x - box_width * 1.38
	if tpos.x < inner_left_edge and tpos.x > outer_left_edge:
		global_position.x += (tpos.x - cpos.x) * speedup_factor * delta

	# Right speedup zone
	var inner_right_edge = cpos.x + inner_box_width * 1.7
	var outer_right_edge = cpos.x + box_width * 1.38
	if tpos.x > inner_right_edge and tpos.x < outer_right_edge:
		global_position.x += (tpos.x - cpos.x) * speedup_factor * delta

	# Top speedup zone
	var inner_top_edge = cpos.z - inner_box_height * 0.8
	var outer_top_edge = cpos.z - box_height * 0.7
	if tpos.z < inner_top_edge and tpos.z > outer_top_edge:
		global_position.z += (tpos.z - cpos.z) * speedup_factor * delta

	# Bottom speedup zone
	var inner_bottom_edge = cpos.z + inner_box_height * 0.8
	var outer_bottom_edge = cpos.z + box_height * 0.7
	if tpos.z > inner_bottom_edge and tpos.z < outer_bottom_edge:
		global_position.z += (tpos.z - cpos.z) * speedup_factor * delta

	super(delta)

func draw_logic() -> void:
	# Draws the outer box
	var outer_mesh_instance := MeshInstance3D.new()
	var outer_immediate_mesh := ImmediateMesh.new()
	var outer_material := ORMMaterial3D.new()

	outer_mesh_instance.mesh = outer_immediate_mesh
	outer_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Adjusted numbers to create an ideal sized box
	var left:float = -box_width * 1.3
	var right:float = box_width * 1.3
	var top:float = -box_height * 0.7
	var bottom:float = box_height * 0.7

	outer_immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, outer_material)
	outer_immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	outer_immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))

	outer_immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	outer_immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))

	outer_immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	outer_immediate_mesh.surface_add_vertex(Vector3(left, 0, top))

	outer_immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	outer_immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	outer_immediate_mesh.surface_end()

	outer_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	outer_material.albedo_color = Color.BLACK

	add_child(outer_mesh_instance)
	outer_mesh_instance.global_transform = Transform3D.IDENTITY
	outer_mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Draws the inner box
	var inner_mesh_instance := MeshInstance3D.new()
	var inner_immediate_mesh := ImmediateMesh.new()
	var inner_material := ORMMaterial3D.new()

	inner_mesh_instance.mesh = inner_immediate_mesh
	inner_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	# Adjusted numbers to create an ideal sized inner box
	var inner_left:float = -inner_box_width * 1.7
	var inner_right:float = inner_box_width * 1.7
	var inner_top:float = -inner_box_height * 0.8
	var inner_bottom:float = inner_box_height * 0.8

	inner_immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, inner_material)
	inner_immediate_mesh.surface_add_vertex(Vector3(inner_right, 0, inner_top))
	inner_immediate_mesh.surface_add_vertex(Vector3(inner_right, 0, inner_bottom))

	inner_immediate_mesh.surface_add_vertex(Vector3(inner_right, 0, inner_bottom))
	inner_immediate_mesh.surface_add_vertex(Vector3(inner_left, 0, inner_bottom))

	inner_immediate_mesh.surface_add_vertex(Vector3(inner_left, 0, inner_bottom))
	inner_immediate_mesh.surface_add_vertex(Vector3(inner_left, 0, inner_top))

	inner_immediate_mesh.surface_add_vertex(Vector3(inner_left, 0, inner_top))
	inner_immediate_mesh.surface_add_vertex(Vector3(inner_right, 0, inner_top))
	inner_immediate_mesh.surface_end()

	inner_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	inner_material.albedo_color = Color.BLACK

	add_child(inner_mesh_instance)
	inner_mesh_instance.global_transform = Transform3D.IDENTITY
	inner_mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	outer_mesh_instance.queue_free()
	inner_mesh_instance.queue_free()
