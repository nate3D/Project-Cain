extends Control
class_name Menu

var options : PackedScene = preload("res://Scenes/Menu/Options.tscn")

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/World/DarkWorld.tscn")


func _on_SettingsButton_pressed():
	get_tree().current_scene.add_child(options.instance())


func _on_QuitButton_pressed():
	get_tree().quit()
