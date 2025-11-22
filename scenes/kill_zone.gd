extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area3D):
	# Si tocamos algo en layer 2 (el player) = atropello
	print("!Se murio el player!")
	# El player ya maneja su propia muerte
	
	# Opcional: destruir el carro después de atropellar
	# queue_free()
