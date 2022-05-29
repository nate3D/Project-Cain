extends KinematicBody2D

onready var anim_sprite : AnimatedSprite = $AnimatedSprite

export var damage = 5

enum State {
	IDLE,
	WALKING,
	DYING
}

var speed : int = 100
var gravity : int = 60
var velocity : Vector2 = Vector2.ZERO

var player : Player = null

var anim = "idle"
var state = State.IDLE

func _ready():
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
		
		velocity = Vector2.ZERO
		if player:
			velocity = Vector2(position.direction_to(player.position).x * speed, 0)
		anim_sprite.flip_h = velocity.x < 0
		velocity += Vector2.DOWN * gravity
		velocity = move_and_slide(velocity, Vector2.UP, true, 4, PI/4, false)
		
	if anim != new_anim:
		anim = new_anim
		anim_sprite.play(anim)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # TODO: Revisit as we don't want to simply erase off-screen enemies

func _on_ChaseArea_body_entered(body):
	if body is Player:
		player = body
		state = State.WALKING
		
func _on_ChaseArea_body_exited(body):
	player = null
	state = State.IDLE

func _die():
	queue_free()
	
func _bullet_collider(contact_collider, state, dp):
	state = State.DYING
	
	state.set_angular_velocity(sign(dp.x) * 33.0)
	contact_collider.disable()
