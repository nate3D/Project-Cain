extends Node

var GameStateManager : Resource = preload("res://Global/GameStateManager.gd")

export var menu_scene = "res://Scenes/Menu/Menu.tscn"
export var main_scene = "res://Scenes/World/DarkWorld.tscn"

var _gameStateManager = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().set_auto_accept_quit(false)	# Must be false to allow pause menu to work on Android
	get_tree().set_quit_on_go_back(false)	# Must be false to allow pause menu to work on Android
	
	_gameStateManager = GameStateManager.new()
	self.add_child(_gameStateManager)
	
	_gameStateManager.Initialise(main_scene, menu_scene)
	
