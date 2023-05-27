extends Control
class_name MainMenu

enum gameCommand { PauseGame, GoHome, QuitApp, ContinueGame }

signal SetActiveScene(args)

var options = "res://Scenes/Menu/Options.tscn"

var scenes = [
		{
			sceneName = "DarkWorld",
			scenePath = "res://Scenes/World/DarkWorld.tscn"
		}
	]

@onready 
var buttonContainer = $VBoxContainer

func _ready():
	for button in buttonContainer.get_children():
		button.connect("pressed", Callable(self, "OnButtonPressed").bind(button.name))

func OnButtonPressed(_name):
	print(str("Clicked ", _name))
	match _name:
		"StartButton":
			print(scenes[0])
			emit_signal("SetActiveScene",  scenes[0])
		"SettingsButton":
			emit_signal("SettingsSelected")
		"QuitButton":
			emit_signal("QuitSelected")
