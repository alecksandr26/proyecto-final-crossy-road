extends Control

func _ready():
	# Conectar botón de jugar
	$VBoxContainer/Button.pressed.connect(_on_play_pressed)
	$VBoxContainer/Button2.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	# Cargar la escena del juego (ajusta la ruta)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_quit_pressed():
	# Salir del juego
	get_tree().quit()
