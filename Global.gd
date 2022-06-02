extends Node

export var menu_scene = "res://Scenes/Menu/Menu.tscn"
export var first_scene = "res://Scenes/World/DarkWorld.tscn"

enum GameState {NEW, IN_PROGRESS, PAUSED}

var current_scene = null
var current_state = GameState.NEW

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	current_state = GameState.NEW
	
func pause(state):
	match state:
		GameState.PAUSED:
			get_tree().paused = false
			current_state = GameState.IN_PROGRESS
		GameState.IN_PROGRESS:
			get_tree().paused = true
			current_state = GameState.PAUSED
			
func quit():
	get_tree().quit()
	
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
