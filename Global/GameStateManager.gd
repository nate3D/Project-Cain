extends "res://Global/GameStateNodeBase.gd"

var ActiveSceneManager : Resource = preload("res://Global/ActiveSceneManager.gd")
var PauseSceneManager : Resource = preload("res://Global/PauseSceneManager.gd")

var _activeSceneManager = null
var _pauseSceneManager = null

var _pauseSceneInstance;

var _currentGameState = gameState.Initialising

func Initialise(homeScenePath, pauseScenePath):
	_activeSceneManager = ActiveSceneManager.new()
	self.add_child(_activeSceneManager)
	_pauseSceneManager = PauseSceneManager.new()
	self.add_child(_pauseSceneManager)
	_activeSceneManager.Initialise(homeScenePath)
	_pauseSceneManager.Initialise(pauseScenePath)
	SetGameState(gameState.PlayingScene)
	print([["Pause",gameCommand.PauseGame], ["Home",gameCommand.GoHome], ["Quit",gameCommand.QuitApp], ["Continue",gameCommand.ContinueGame]])

func ExecuteGameCommand(command):
	print(["ExecuteGameCommand", command])
	match command:
		gameCommand.GoHome:
			SetGameState(gameState.PlayingScene)
			_activeSceneManager.Home();
			_pauseSceneManager.Hide()
		gameCommand.PauseGame:
			SetGameState(gameState.GamePaused)
			_pauseSceneManager.Show()
		gameCommand.ContinueGame:
			SetGameState(gameState.PlayingScene)
			_pauseSceneManager.Hide()
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
