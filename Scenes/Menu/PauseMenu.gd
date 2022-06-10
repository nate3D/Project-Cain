extends Control
class_name PauseMenu

enum gameCommand { PauseGame, GoHome, QuitApp, ContinueGame }

signal SettingsSelected
signal QuitSelected
signal StartSelected
signal ResumeSelected

var options = "res://Scenes/Menu/Options.tscn"

onready var buttonContainer = $VBoxContainer

func _ready():
	for button in buttonContainer.get_children():
		button.connect("pressed", self, "OnButtonPressed", [ button.name ])

func OnButtonPressed(name):
	print(str("Clicked ", name))
	match name:
		"ResumeButton":
			emit_signal("ResumeSelected")
		"StartButton":
			emit_signal("StartSelected")
		"SettingsButton":
			emit_signal("SettingsSelected")
		"QuitButton":
			emit_signal("QuitSelected")
