extends Control


var PLAYER : CharacterBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PLAYER = get_parent().get_parent().find_child("CharacterBody3D")
	
	$Button.pressed.connect(_on_up_pressed)
	$Button3.pressed.connect(_on_down_pressed)
	$Button2.pressed.connect(_on_left_pressed)
	$Button4.pressed.connect(_on_rigth_pressed)

func _on_rigth_pressed():
	PLAYER.do_jump(Vector3(0, 0, 1))

func _on_left_pressed():
	PLAYER.do_jump(Vector3(0, 0, -1))

func _on_down_pressed():
	PLAYER.do_jump(Vector3(-1, 0, 0))

func _on_up_pressed():
	PLAYER.do_jump(Vector3(1, 0, 0))
