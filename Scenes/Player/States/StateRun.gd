extends BasePlayerState

@export 
var run_speed : float = 500: get = get_run_speed, set = set_run_speed

func set_run_speed(new_speed):
	run_speed = new_speed
	
func get_run_speed():
	return run_speed

func run(player: CharacterBody2D):
	player.play("run")
	if player.vertical > 0:
		player.collision_layer = 1
		player.platform_timer.start()
	player.vx = player.horizontal * run_speed
	player.apply_gravity(player.gravity)
	player.move()
	if player.ladder_area and (\
		(player.vertical < 0 and not player.ladder_tip) or\
		(player.vertical > 0 and player.ladder_tip)\
	):
		return "ladder"
	if !player.running:
		return "walk"
	if player.underwater:
		return "swim"
	if not player.is_on_floor():
		return "air"
	if player.vy > 0:
		player.vy = 0
	if player.jumping:
		return "jump"
	if player.horizontal == 0:
		return "idle"
	return null
