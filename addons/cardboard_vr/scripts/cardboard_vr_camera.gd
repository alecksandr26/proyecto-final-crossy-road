class_name CardboardVRCamera extends Camera3D

@export var Active : bool = true

@export_category("Controls")
@export var UseGyroscope : bool = false
@export var UseMouseControl : bool = true
@export var Mouse_Sensitivity : float = 0.003
@export var GyroscopeFactor : float = 0.5
@export var Handle_Mouse_Capture : bool = true
@export var Input_Cancel : String = "ui_cancel"

@export_category("Eyes")
@export_range(0.01, 0.2) var EyesSeparation : float = 0.065
@export_range(-10, 10) var EyeConvergencyAngle : float = 0

@export_category("Camera Setup")
@export var follow_target : Node3D
@export var height_offset : float = 30.0
@export var distance_offset : float = 18.0

# ← Controles de tamaño y posición de las vistas
@export_category("Viewport Adjustments")
@export_range(0.1, 1.0) var viewport_scale : float = 1.0
@export_range(-500, 500) var horizontal_offset : float = 0.0
@export_range(-500, 500) var vertical_offset : float = 0.0

var viewScene = preload("res://addons/cardboard_vr/scenes/CardboardView.tscn")
var left_camera_3d: Camera3D = Camera3D.new()
var right_camera_3d: Camera3D = Camera3D.new()
var LeftEyePivot : Node3D = Node3D.new()
var RightEyePivot : Node3D = Node3D.new()
var View : CardboardView
var LeftEyeSubViewPort : SubViewport = SubViewport.new()
var RightEyeSubViewPort : SubViewport = SubViewport.new()

var user_rotation : Vector3 = Vector3.ZERO

func _input(event):	
	if not Active:
		return
	
	if Handle_Mouse_Capture:
		if event is InputEventMouseButton:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif Input.is_action_just_pressed(Input_Cancel):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE	
	
	if UseMouseControl and event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		user_rotation.y -= (event as InputEventMouseMotion).relative.x * Mouse_Sensitivity
		user_rotation.x -= (event as InputEventMouseMotion).relative.y * Mouse_Sensitivity
		user_rotation.x = clamp(user_rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _ready() -> void:
	follow_target = get_parent()
	
	# Configurar SubViewports con escala ajustable
	var viewport_size = get_viewport().size
	var scaled_size = viewport_size * viewport_scale
	
	LeftEyeSubViewPort.size = scaled_size
	RightEyeSubViewPort.size = scaled_size
	LeftEyeSubViewPort.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	RightEyeSubViewPort.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	var main_world = get_viewport().world_3d
	LeftEyeSubViewPort.world_3d = main_world
	RightEyeSubViewPort.world_3d = main_world
	
	add_child(LeftEyeSubViewPort)
	add_child(RightEyeSubViewPort)
	
	LeftEyeSubViewPort.add_child(LeftEyePivot)
	RightEyeSubViewPort.add_child(RightEyePivot)
	
	LeftEyePivot.add_child(left_camera_3d)
	RightEyePivot.add_child(right_camera_3d)
	
	# Copiar propiedades
	left_camera_3d.fov = fov
	right_camera_3d.fov = fov
	left_camera_3d.near = near
	right_camera_3d.near = near
	left_camera_3d.far = far
	right_camera_3d.far = far
	left_camera_3d.cull_mask = cull_mask
	right_camera_3d.cull_mask = cull_mask
	
	# Separación de ojos
	left_camera_3d.position.x = -EyesSeparation
	right_camera_3d.position.x = EyesSeparation
	
	if EyeConvergencyAngle != 0:
		left_camera_3d.rotate_object_local(Vector3.UP, deg_to_rad(EyeConvergencyAngle))
		right_camera_3d.rotate_object_local(Vector3.UP, -deg_to_rad(EyeConvergencyAngle))
	
	View = viewScene.instantiate()
	add_child(View)
	View.SetViewPorts(LeftEyeSubViewPort, RightEyeSubViewPort)
	
	# Aplicar ajustes de posición al View después de un frame
	await get_tree().process_frame
	apply_view_adjustments()
	
	update_pivot_transforms()
	
	print("✅ CardboardVRCamera inicializada")
	print("   - Viewport Scale: ", viewport_scale)
	print("   - Scaled Size: ", scaled_size)
	print("   - Horizontal Offset: ", horizontal_offset)

func apply_view_adjustments():
	# Buscar los nodos Control dentro del CardboardView
	var control_node = find_control_in_view(View)
	
	if control_node:
		# Escalar y desplazar el Control
		control_node.scale = Vector2(viewport_scale, viewport_scale)
		control_node.position = Vector2(horizontal_offset, vertical_offset)
		
		print("📐 View adjustments applied to Control")
		print("   - Scale: ", control_node.scale)
		print("   - Position: ", control_node.position)
	else:
		print("⚠️ No se encontró Control node en CardboardView")

func find_control_in_view(node: Node) -> Control:
	# Buscar recursivamente un nodo de tipo Control
	if node is Control:
		return node
	
	for child in node.get_children():
		var result = find_control_in_view(child)
		if result:
			return result
	
	return null

func update_pivot_transforms():
	if follow_target:
		var target_pos = follow_target.global_position
		global_position = Vector3(target_pos.x, target_pos.y + height_offset, target_pos.z + distance_offset)
	
	LeftEyePivot.global_transform = global_transform
	RightEyePivot.global_transform = global_transform
	
	LeftEyePivot.rotate_object_local(Vector3.UP, user_rotation.y)
	LeftEyePivot.rotate_object_local(Vector3.RIGHT, user_rotation.x)
	RightEyePivot.rotate_object_local(Vector3.UP, user_rotation.y)
	RightEyePivot.rotate_object_local(Vector3.RIGHT, user_rotation.x)

func _process(delta: float) -> void:	
	if not Active:
		return
	
	update_pivot_transforms()
	
	if UseGyroscope:
		var gyroscope = Input.get_gyroscope()
		
		if gyroscope.length() > 0.001:
			user_rotation.y += gyroscope.y * GyroscopeFactor * delta
			user_rotation.x += gyroscope.x * GyroscopeFactor * delta
			user_rotation.x = clamp(user_rotation.x, deg_to_rad(-90), deg_to_rad(90))

func get_head_rotation() -> Vector3:
	return Vector3(rad_to_deg(user_rotation.x), rad_to_deg(user_rotation.y), 0)

func reset_view():
	user_rotation = Vector3.ZERO
	print("🔄 Vista reseteada")

# Método para ajustar en tiempo real
func set_viewport_adjustments(scale: float, h_offset: float, v_offset: float):
	viewport_scale = scale
	horizontal_offset = h_offset
	vertical_offset = v_offset
	
	# Aplicar los cambios
	var viewport_size = get_viewport().size
	var scaled_size = viewport_size * viewport_scale
	
	LeftEyeSubViewPort.size = scaled_size
	RightEyeSubViewPort.size = scaled_size
	
	apply_view_adjustments()
	
	print("🔧 Adjustments updated: scale=", scale, " h_offset=", h_offset, " v_offset=", v_offset)
