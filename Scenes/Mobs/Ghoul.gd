extends KinematicBody2D

onready var anim_sprite : AnimatedSprite = $AnimatedSprite
onready var raycast : RayCast2D = $RayCast2D

export (Resource) var Health setget , _get_health
var attack_damage : int = 5
var attack_cooldown_time : int = 1500
var next_attack_time : int = 0

enum State {
	IDLE,
	WALKING,
	DYING,
	ATTACKING
}

var speed : int = 100
var gravity : int = 60
var velocity : Vector2 = Vector2.ZERO

var player : Player = null

var anim = "idle"
var state = State.IDLE

func _ready():
	Health.connect("health_zero", self, "_die")
	anim_sprite.playing = true
	anim_sprite.play('idle')

func _physics_process(delta):
	var new_anim = anim
	
	if state == State.IDLE:
		new_anim = "idle"
	elif state == State.DYING:
		new_anim = "dying"
	elif state == State.WALKING:
		new_anim = "walk"
		
		if player:
			velocity = Vector2(position.direction_to(player.position).x * speed, 0)
		anim_sprite.flip_h = velocity.x < 0
		raycast.cast_to.y = velocity.normalized().x * 22
		velocity += Vector2.DOWN * gravity
		velocity = move_and_slide(velocity, Vector2.UP, true, 4, PI/4, false)
		
	elif state == State.ATTACKING:
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			var target = raycast.get_collider()
			if target and target is Player and player._get_health() > 0:
				new_anim = 'attack'
				next_attack_time = now + attack_cooldown_time
		
	if anim != new_anim:
		anim = new_anim
		anim_sprite.play(anim)
	
			
func hit(damage):
	Health.take_damage(damage)
	
func _die():
	velocity = Vector2.ZERO
	anim_sprite.play('dying')
	yield(anim_sprite, "animation_finished")
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # TODO: Revisit as we don't want to simply erase off-screen enemies

func _on_ChaseArea_body_entered(body):
	if body is Player:
		player = body
		state = State.WALKING
		
func _on_ChaseArea_body_exited(body):
	if body is Player:
		player = null
		state = State.IDLE

func _on_AttackArea_body_entered(body):
	if body is Player:
		state = State.ATTACKING

func _on_AttackArea_body_exited(body):
	if body is Player:
		state = State.WALKING

func _on_AnimatedSprite_frame_changed():
	if anim_sprite.animation == 'attack' and anim_sprite.frame == 2:
		var target = raycast.get_collider()
		if target and target is Player and player._get_health() > 0:
			player.hit(attack_damage)
			yield(anim_sprite, "animation_finished")

func _get_health():
	return Health._get_current_health()
