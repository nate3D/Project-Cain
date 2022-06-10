extends Node

export var menu_scene = "res://Scenes/Menu/PauseMenu.tscn"
export var main_scene = "res://Scenes/Menu/MainMenu.tscn"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().set_auto_accept_quit(false)	# Must be false to allow pause menu to work on Android
	get_tree().set_quit_on_go_back(false)	# Must be false to allow pause menu to work on Android
	
	$GameStateManager.Initialise(main_scene, menu_scene)
	
