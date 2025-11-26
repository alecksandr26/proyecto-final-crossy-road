extends Control

func _ready():
	# Mostrar monedas recogidas
	$VBoxContainer/Label2.text = "Monedas recogidas: " + str(Global.coins)
	
	# Conectar botones
	$VBoxContainer/Button.pressed.connect(_on_retry_pressed)
	$VBoxContainer/Button2.pressed.connect(_on_quit_pressed)

func _on_retry_pressed():
	# Reiniciar el nivel
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed():
	# Volver al menú principal
	get_tree().quit()
