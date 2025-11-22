extends Area3D

func _ready():
	# Conectar señal para detectar cuando algo nos toca
	area_entered.connect(_on_area_entered)

func get_player_node() -> CharacterBody3D:
	return get_parent().get_parent()

func _on_area_entered(area: Area3D):
	# get_parent() para llegar al CharacterBody3D
	get_player_node().die()
