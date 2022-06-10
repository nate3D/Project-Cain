extends "res://Global/GameStateNodeBase.gd"

var _currentGameState = gameState.Initialising

func Initialise(homeScenePath, pauseScenePath):
	$ActiveSceneManager.Initialise(homeScenePath)
	$PauseSceneManager.Initialise(pauseScenePath)
	SetGameState(gameState.PlayingScene)
	Global.connect("PauseGame", self, "ExecuteGameCommand", [ gameCommand.PauseGame ])
	print([["Pause",gameCommand.PauseGame], ["Home",gameCommand.GoHome], ["Quit",gameCommand.QuitApp], ["Continue",gameCommand.ContinueGame]])

func ExecuteGameCommand(command):
	print(["ExecuteGameCommand", command])
	match command:
		gameCommand.GoHome:
			SetGameState(gameState.PlayingScene)
			$ActiveSceneManager.Home()
			$PauseSceneManager.Hide()
		gameCommand.PauseGame:
			SetGameState(gameState.GamePaused)
			$PauseSceneManager.Show()
		gameCommand.ContinueGame:
			SetGameState(gameState.PlayingScene)
			$PauseSceneManager.Hide()
		gameCommand.QuitApp:
			get_tree().quit()

func SetGameState(state):
	match state:
		gameState.GamePaused:
			get_tree().paused = true
		gameState.PlayingScene:
			get_tree().paused = false
	_currentGameState = state

func _notification(what):
	print(["Notification", what])
	match (what):
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			ExecuteGameCommand(gameCommand.PauseGame)
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			ExecuteGameCommand(gameCommand.QuitApp)
		MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
			ExecuteGameCommand(gameCommand.PauseGame)
