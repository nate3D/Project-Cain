extends "res://Global/GameStateNodeBase.gd"

var _homeSceneInstance;
var _activeSceneInstance

func Initialise(homeScenePath):
	_homeSceneInstance = load(homeScenePath).instantiate()
	Home()

func SetActiveScene(args):
	var nodeInstance
	if (args.has("sceneInstance")):
		nodeInstance = args.sceneInstance
	elif (args.has("scenePath")):
		nodeInstance = load(args.scenePath).instantiate()
	else:
		return
	
	if (args.has("sceneName")):
		print(["Playing Scene", args.sceneName])

	RemoveActiveScene()

	_activeSceneInstance = nodeInstance
	_activeSceneInstance.connect("SetActiveScene", Callable(self, "SetActiveScene"))

	self.add_child(nodeInstance)

func RemoveActiveScene():
	if (_activeSceneInstance == null):
		return
	_activeSceneInstance.disconnect("SetActiveScene", Callable(self, "SetActiveScene"))
	remove_child(_activeSceneInstance)
	_activeSceneInstance = null

func Home():
	SetActiveScene({ sceneInstance = _homeSceneInstance, sceneName = "Home"})
