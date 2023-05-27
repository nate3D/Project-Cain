extends Node2D
class_name BasePlayerState

@export var tag : String = ""

func _ready():
	tag = name.to_lower()


#################################################
# Player State Base
#################################################
func enter(player: CharacterBody2D):
	player.play(tag)

func run(_player: CharacterBody2D):
	return null

func exit(player: CharacterBody2D):
	if player and player.anim:
		player.anim.clear_queue()
#################################################
