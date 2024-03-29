extends Node2D
class_name PlayerFSM

var states : Dictionary = {}
var active_state: BasePlayerState
var player : CharacterBody2D

func generate_state_dictionary():
	for state in get_children():
		if state.tag:
			states[state.tag] = state

func init(_player: CharacterBody2D):
	self.player = _player
	generate_state_dictionary()
	active_state = states.idle
	active_state.enter(self.player)

func run():
	var next_state_tag = active_state.run(player)
	if next_state_tag:
		change_state(next_state_tag)

func change_state(next_state_tag : String):
	var next_state = states.get(next_state_tag)
	if next_state:
		active_state.exit(player)
		active_state = next_state
		active_state.enter(player)
