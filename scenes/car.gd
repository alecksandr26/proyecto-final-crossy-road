extends Area3D

# === PARÁMETROS ===
@export var speed: float = 15.0
# La dirección se calcula automáticamente según la rotación Y del carro
var parent_rotation_y: float  # Rotación del nodo padre (car2, car3, etc.)

func _ready():
	# Obtener rotación del nodo padre (car2, car3, etc.)
	if get_parent():
		parent_rotation_y = get_parent().rotation.y
	else:
		parent_rotation_y = 0
	
	# Conectar señal de colisión
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	# Determinar dirección basada en la rotación Y del PADRE
	var direction = Vector3.ZERO
	
	# Si está rotado -90° → mover hacia Z+
	# Si está rotado +90° → mover hacia Z-
	if parent_rotation_y < 0:  # rotación negativa (-90°)
		direction = Vector3(0, 0, 1)  # Z+
	else:  # rotación positiva (+90°)
		direction = Vector3(0, 0, -1)  # Z-
	
	global_position += direction * speed * delta
	
func _on_area_entered(area: Area3D):
	# Si tocamos algo en layer 2 (el player) = atropello
	print("¡Atropellé al player!")
	# El player ya maneja su propia muerte
	
	# Opcional: destruir el carro después de atropellar
	# queue_free()
