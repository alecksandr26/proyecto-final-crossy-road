extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area3D):
	# get_parent() para llegar al CharacterBody3D
	print("Fin del juego ganaste!!!!")
	
	set_physics_process(false)
	set_process_input(false)

	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/win_menu.tscn")
