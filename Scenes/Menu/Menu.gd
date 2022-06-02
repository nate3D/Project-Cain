extends Control
class_name Menu

var options = "res://Scenes/Menu/Options.tscn"

onready var resume_button : Button = $VBoxContainer/ResumeButton

func _ready():
	resume_button.disabled = true
	resume_button.visible = false

func _on_ResumeButton_pressed():
	Global.pause(Global.GameState.IN_PROGRESS)
	
func _on_StartButton_pressed():
	Global.pause(Global.GameState.PAUSED)
	Global.goto_scene(Global.first_scene)

func _on_SettingsButton_pressed():
	Global.goto_scene(options)

func _on_QuitButton_pressed():
	Global.quit()
