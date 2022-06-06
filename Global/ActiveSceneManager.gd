extends "res://Global/GameStateNodeBase.gd"

signal SetActiveScene(args)

var _homeSceneInstance;
var _activeSceneInstance

func Initialise(homeScenePath):
	_homeSceneInstance = load(homeScenePath).instance()
	Home()

func SetActiveScene(args):
	var nodeInstance
	if (args.has("sceneInstance")):
		nodeInstance = args.sceneInstance
	elif (args.has("scenePath")):
		nodeInstance = load(args.scenePath).instance()
	else:
		return
	
	if (args.has("sceneName")):
		print(["Playing Scene", args.sceneName])

	RemoveActiveScene()

	_activeSceneInstance = nodeInstance
	_activeSceneInstance.connect("SetActiveScene", self, "SetActiveScene") 
	self.add_child(nodeInstance)

func RemoveActiveScene():
	if (_activeSceneInstance == null):
		return
	_activeSceneInstance.disconnect("SetActiveScene", self, "SetActiveScene")
	remove_child(_activeSceneInstance)
	_activeSceneInstance = null

func Home():
	SetActiveScene({ sceneInstance = _homeSceneInstance, sceneName = "Home"})
