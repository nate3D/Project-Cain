extends KinematicBody2D
class_name Player
signal hud

export var gravity : float = 60

export (PackedScene) var Bullet
export (Resource) var Health

var horizontal : int = 0
var vertical : int = 0
var up : bool = false
var velocity: Vector2 = Vector2.ZERO
var vx: float = 0 setget _set_vx, _get_vx
var vy: float = 0 setget _set_vy, _get_vy

var underwater : bool = false
var running : bool = false
var grounded : bool = false setget ,_get_grounded
var jumping : bool = false setget ,_get_jumping
var shooting : bool = false setget ,_get_shooting
var ladder_area : bool = false
var ladder_tip : bool = false
var ladder_x : float
var flip : bool = false

onready var jump_timer : Timer = $Timers/JumpTimer
onready var floor_timer : Timer = $Timers/FloorTimer
onready var ladder_timer : Timer = $Timers/LadderTimer
onready var platform_timer : Timer = $Timers/PlatformTimer
onready var shoot_timer : Timer = $Timers/ShootTimer
onready var sprite : Sprite = $Gunslinger
onready var anim : AnimationPlayer = $Gunslinger/AnimationPlayer
onready var state_machine: PlayerFSM = $PlayerStates
onready var tween : Tween = $Tween
onready var waves : Particles2D = $Waves
onready var gun_pivot : Position2D = $GunPivot
onready var gun1 : Sprite = $GunPivot/Gun1
onready var gun1_anim : AnimationPlayer = $GunPivot/Gun1/AnimationPlayer

func _ready():
	state_machine.init(self)
	Health.reset()

func _physics_process(delta):
	update_inputs()
	update_player()
	state_machine.run()
	emit_signal("hud", "%s" % state_machine.active_state.tag)

func update_inputs():
	horizontal = (
		int(Input.is_action_pressed("ui_right"))
		- int(Input.is_action_pressed("ui_left"))
	)
	vertical = (
		int(Input.is_action_pressed("ui_down"))
		- int(Input.is_action_pressed("ui_up"))
	)
	up = Input.is_action_pressed("ui_up")
	if Input.is_action_just_pressed("shoot") && not _get_shooting():
		shoot()
		shoot_timer.start()
	running = Input.is_action_pressed("run")
	if Input.is_action_just_pressed("ui_accept"):
		jump_timer.start()
	if is_on_floor():
		floor_timer.start()
		
func update_player():
	sprite.flip_h = flip
	gun1.flip_v = flip

func move():
	var old = velocity
	velocity = move_and_slide(velocity, Vector2.UP, true)

func apply_gravity (gravity:float):
	velocity += Vector2.DOWN * gravity

func play(animation:String):
	if anim.current_animation == animation:
		return
	anim.play(animation)

func tween_to_ladder():
	var target = Vector2(ladder_x, position.y)
	tween.interpolate_property(self, "position", position, target,
		0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func can_climb():
	return ladder_area and ladder_timer.is_stopped()
	
func shoot():
	var b = Bullet.instance()
	owner.add_child(b)
	b.shoot(get_global_mouse_position(), gun1.global_position)
	gun1_anim.play('shoot')
	yield(gun1_anim, "animation_finished")
	gun1_anim.play('idle')

###########################################################
# Setget
###########################################################
func _get_vx():
	return vx
func _set_vx(val:float):
	if val != 0:
		flip = (val < 0)
	velocity.x = val
	vx = val

func _get_vy():
	return vy
func _set_vy(val:float):
	velocity.y = val
	vy = val

func _get_grounded():
	grounded = not floor_timer.is_stopped()
	return grounded

func _get_jumping():
	jumping = not jump_timer.is_stopped()
	return jumping
	
func _get_shooting():
	shooting = not shoot_timer.is_stopped()
	return shooting
###########################################################

func _on_PlatformTimer_timeout():
	collision_layer = 1 | 2
