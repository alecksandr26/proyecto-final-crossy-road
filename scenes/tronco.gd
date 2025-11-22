extends AnimatableBody3D

@export var speed: float = 15.0
var parent_rotation_y: float  # Rotación del nodo padre 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Obtener rotación del nodo padre 
	if get_parent():
		parent_rotation_y = get_parent().rotation.y
	else:
		parent_rotation_y = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	# Determinar dirección basada en la rotación Y del PADRE
	var direction = Vector3.ZERO
	if parent_rotation_y < 0:
		direction = Vector3(0, 0, 1)  # Z+
	else:
		direction = Vector3(0, 0, -1)  # Z-
		
	global_position += direction * speed * delta
