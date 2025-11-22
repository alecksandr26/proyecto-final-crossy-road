extends CharacterBody3D

# === PARÁMETROS (ajusta aquí) ===
@export var SPEED: float = 20.0            # velocidad horizontal inicial
@export var MAX_SPEED: float = 40.0        # velocidad máxima con combo
@export var SPEED_BOOST: float = 1       # cuánto aumenta por salto rápido
@export var COMBO_TIME_WINDOW: float = 0.6 # tiempo para mantener el combo (segundos)

@export var JUMP_FORCE: float = 2*8.0      # impulso vertical inicial
@export var GRAVITY: float = 7*9.8         # gravedad
@export var JUMP_DURATION: float = 0.5     # tiempo aproximado del impulso en segundos

@export var auto_play_on_start: bool = true

# Cámara
@export var camera_offset: Vector3 = Vector3(0, 24, 0)
@export var camera_lerp_speed: float = 5.0
var cam_rig: Node3D = null

# --- Estado interno ---
var target_direction: Vector3 = Vector3.ZERO
var jumping: bool = false
var jump_timer: float = 0.0

# Sistema de aceleración por clicks
var current_speed: float = 20.0           # velocidad actual
var last_click_time: float = 0.0          # último tiempo de click
var click_count: int = 0                  # contador de clicks en ventana de tiempo
var speed_multiplier: float = 1.0         # multiplicador de velocidad

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cam_rig = get_parent().get_node_or_null("CameraRig")
	current_speed = SPEED  # inicializar velocidad actual
	
	if auto_play_on_start:
		# Esperar un poco antes de empezar (para que todo cargue)
		await get_tree().create_timer(0.5).timeout
		moves_to_complete_the_game()

func _physics_process(delta: float) -> void:
	# --- gravedad ---
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		if jumping and jump_timer <= 0.0:
			jumping = false
			target_direction = Vector3.ZERO
	
	# --- movimiento del salto ---
	if jumping:
		jump_timer -= delta
		if target_direction != Vector3.ZERO:
			# Usar current_speed (velocidad con combo)
			var move_vec = target_direction.normalized() * current_speed
			velocity.x = move_vec.x
			velocity.z = move_vec.z
	else:
		# desacelerar si no se está saltando
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)
	
	# aplicar movimiento físico
	move_and_slide()
	
	# --- rotar el personaje ---
	if target_direction != Vector3.ZERO and jumping:
		var target_yaw = atan2(-target_direction.z, target_direction.x)
		rotation.y = lerp_angle(rotation.y, target_yaw, delta * 10.0)
	
	# Actualizar cámara
	if cam_rig:
		cam_rig.update_camera_position(position)

func _input(event):
	# Detectar cualquier tecla de movimiento presionada
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or \
	   event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		
		# Registrar el click para calcular velocidad
		register_click()
		
		# Ejecutar el salto correspondiente
		if event.is_action_pressed("ui_up"):
			do_jump(Vector3(1, 0, 0))
		elif event.is_action_pressed("ui_down"):
			do_jump(Vector3(-1, 0, 0))
		elif event.is_action_pressed("ui_left"):
			do_jump(Vector3(0, 0, -1))
		elif event.is_action_pressed("ui_right"):
			do_jump(Vector3(0, 0, 1))

func register_click() -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	var time_since_last_click = current_time - last_click_time
	
	# Si clickeaste rápido (dentro de la ventana de tiempo)
	if time_since_last_click <= COMBO_TIME_WINDOW and last_click_time > 0:
		click_count += 1
		# Aumentar velocidad progresivamente
		speed_multiplier = 1.0 + (click_count * 0.2)  # +20% por cada click rápido
		speed_multiplier = min(speed_multiplier, MAX_SPEED / SPEED)  # limitar al máximo
		current_speed = SPEED * speed_multiplier
		print("⚡ CLICKS: ", click_count, " | Velocidad: x", snappedf(speed_multiplier, 0.1), " (", int(current_speed), ")")
	else:
		# Reset si tardaste mucho entre clicks
		click_count = 1
		speed_multiplier = 1.0
		current_speed = SPEED
	
	last_click_time = current_time

func do_jump(direction: Vector3) -> void:
	if is_on_floor() and not jumping:
		jumping = true
		jump_timer = JUMP_DURATION
		target_direction = direction
		velocity.y = JUMP_FORCE

func die():
	print("Game Over - Toy Morido :(")
	
	# Opción 1: Desaparecer completamente
	# queue_free()
	
	
	# Opción 2: Reiniciar el nivel (comenta la línea de arriba y usa esta)
	# get_tree().reload_current_scene()
	
	# Opción 3: Desactivar controles, hacer invisible y cambiar escena
	visible = false
	
	set_physics_process(false)
	set_process_input(false)

	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/game_over_menu.tscn")
	
	
	
	
func moves_to_complete_the_game():
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(0, 0, 1))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(0, 0, 1))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(0, 0, -1))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(0, 0, -1))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(0, 0, -1))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(4.0).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(3.0).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(4.0).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))
	await get_tree().create_timer(0.55).timeout
	do_jump(Vector3(1, 0, 0))	

	
	
	
