extends Area3D

# Distancia a la que respawnear el carro
@export var respawn_distance: float = 150.0

func _ready():
	# Conectar señal
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D):
	# Solo puede entrar algo del layer 3 (enemigos) por la configuración de máscaras
	
	# Obtener posición del carro y del trigger
	var car_position = area.global_position
	var trigger_position = global_position
	
	# Calcular de qué lado llegó el carro (en el eje Z)
	var diff_z = car_position.z - trigger_position.z
	
	var respawn_offset = Vector3.ZERO
	
	# Si el carro llegó desde Z+ (diff_z > 0), respawnear hacia Z+
	if diff_z > 0:
		respawn_offset = Vector3(0, 0, respawn_distance)
	# Si llegó desde Z- (diff_z < 0), respawnear hacia Z-
	else:
		respawn_offset = Vector3(0, 0, -respawn_distance)	
	# Mover el carro
	area.global_position += respawn_offset
