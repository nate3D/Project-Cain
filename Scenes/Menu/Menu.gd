extends Control
class_name Menu

signal OptionsSelected()
signal QuitSelected()
signal StartSelected()

onready var buttonContainer = $VBoxContainer

func _ready():
	for button in buttonContainer.get_children():
		button.connect("pressed", self, "OnButtonPressed")
		
func OnButtonPressed(id):
	print(str("Clicked ", id))
	match id:
		"StartButton":
			emit_signal("StartSelected")
		"SettingsButton":
			emit_signal("OptionsSelected")
		"QuitButton":
			emit_signal("QuitSelected")
