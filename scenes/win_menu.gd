extends Control

func _ready():
	# Mostrar monedas recogidas
	$VBoxContainer/Label2.text = "Monedas recogidas: " + str(Global.coins)
	
	# Conectar botones
	$VBoxContainer/Button.pressed.connect(_on_menu_pressed)
	$VBoxContainer/Button2.pressed.connect(_on_quit_pressed)

func _on_menu_pressed():
	# Volver al menú principal
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed():
	# Salir del juego
	get_tree().quit()
