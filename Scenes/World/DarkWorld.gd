extends Node

@export 
var screen_size : Vector2

signal SetActiveScene(args)

var Player : PackedScene = load("res://Scenes/Player/Player.tscn")
var Ghoul : PackedScene = load("res://Scenes/Mobs/Ghoul.tscn")
var _rand : RandomNumberGenerator = RandomNumberGenerator.new()
var player

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	player = Player.instantiate()
	Global.player_instance = player
	add_child(player)
	player.set_owner(self)
	randomize()

func _on_GhoulSpawn_timeout():
	for i in range(0,10):
		var ghoul_inst = Ghoul.instantiate()
		var x = _rand.randf_range(0, screen_size.x)
		var y = _rand.randf_range(0, screen_size.y)
		ghoul_inst.position.y = y
		ghoul_inst.position.x = x
		add_child(ghoul_inst)
	
