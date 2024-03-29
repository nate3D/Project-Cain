extends BasePlayerState

@export 
var climb_speed : float = 200

func enter(player: CharacterBody2D):
	player.tween_to_ladder()
	super.enter(player)
	player.anim.playback_active = false
	player.collision_layer = 1

func run(player: CharacterBody2D):
	player.vx = 0
	if player.underwater:
		player.vy = player.vertical * climb_speed / 2
	else:
		player.vy = player.vertical * climb_speed
	player.anim.playback_active = (player.vertical != 0)
	player.move()
	if player.jumping:
		return "walk"
	if player.grounded and player.vertical > 0:
		return "idle"
	if not player.ladder_area:
		return "air"
	return null

func exit(player: CharacterBody2D):
	super.exit(player)
	player.anim.playback_active = true
	player.collision_layer = 1 | 2
	player.ladder_timer.start()
