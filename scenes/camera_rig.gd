extends Node3D

@onready var camera = $CardboardVRCamera3D
var offset = Vector3(-6, 3, 0)  # posición relativa al jugador
var smooth_speed = 5.0          # suavizado opcional

func update_camera_position(player_pos: Vector3):
	# Calcula nueva posición deseada (mantiene orientación actual)
	var target = player_pos + offset
	position = position.lerp(target, get_process_delta_time() * smooth_speed)
