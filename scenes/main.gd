extends Node3D

func _ready():
	# Conectar el label al sistema global
	Global.coin_label = $player/UI/CanvasLayer/Label
	Global.reset_coins()  # empezar en 0
