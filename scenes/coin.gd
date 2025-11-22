extends Area3D

@export var rotation_speed: float = 2.0  # velocidad de rotación

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	get_parent().rotation.y += rotation_speed * delta

func _on_area_entered(area: Area3D):
	Global.add_coin()
	get_parent().queue_free()
