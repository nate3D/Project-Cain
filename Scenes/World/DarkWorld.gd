extends Node

export(PackedScene) var Ghoul

export var screen_size : Vector2
signal SetActiveScene(args)

var _rand : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	randomize()

func _on_GhoulSpawn_timeout():
	for i in range(0,10):
		var ghoul_inst = Ghoul.instance()
		var x = _rand.randf_range(0, screen_size.x)
		var y = _rand.randf_range(0, screen_size.y)
		ghoul_inst.position.y = y
		ghoul_inst.position.x = x
		add_child(ghoul_inst)
	
