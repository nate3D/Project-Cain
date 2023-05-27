extends "res://Global/GameStateNodeBase.gd"

var _pauseSceneInstance

@onready 
var _pauseMenuLayer : CanvasLayer = $PauseMenuLayer

func Initialise(pauseScenePath):
	var gameStateManager = self.get_parent()
	_pauseSceneInstance = load(pauseScenePath).instantiate()
	_pauseSceneInstance.connect("SettingsSelected", Callable(gameStateManager, "ExecuteGameCommand").bind(gameCommand.GoHome))
	_pauseSceneInstance.connect("QuitSelected", Callable(gameStateManager, "ExecuteGameCommand").bind(gameCommand.QuitApp))
	_pauseSceneInstance.connect("StartSelected", Callable(gameStateManager, "ExecuteGameCommand").bind(gameCommand.ContinueGame))
	_pauseSceneInstance.connect("ResumeSelected", Callable(gameStateManager, "ExecuteGameCommand").bind(gameCommand.ContinueGame))
	_pauseSceneInstance.hide()
	
	_pauseMenuLayer.add_child(_pauseSceneInstance)

func Hide():
	_pauseSceneInstance.hide()
	
func Show():
	_pauseSceneInstance.show()
