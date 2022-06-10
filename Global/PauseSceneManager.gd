extends "res://Global/GameStateNodeBase.gd"

var _pauseSceneInstance

func Initialise(pauseScenePath):
	var gameStateManager = self.get_parent()
	_pauseSceneInstance = load(pauseScenePath).instance()
	_pauseSceneInstance.connect("SettingsSelected", gameStateManager, "ExecuteGameCommand", [ gameCommand.GoHome ])
	_pauseSceneInstance.connect("QuitSelected", gameStateManager, "ExecuteGameCommand", [ gameCommand.QuitApp ])
	_pauseSceneInstance.connect("StartSelected", gameStateManager, "ExecuteGameCommand", [ gameCommand.ContinueGame ])
	_pauseSceneInstance.connect("ResumeSelected", gameStateManager, "ExecuteGameCommand", [ gameCommand.ContinueGame ])
	_pauseSceneInstance.hide()
	
	self.add_child(_pauseSceneInstance)

func Hide():
	_pauseSceneInstance.hide()
	
func Show():
	_pauseSceneInstance.show()
