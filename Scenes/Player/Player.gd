extends KinematicBody2D
class_name Player

signal hud

export var gravity : float = 60

export (PackedScene) var Bullet
export (Resource) var Health setget , _get_health

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
var ladder_area : bool = false
var ladder_tip : bool = false
var ladder_x : float
var flip : bool = false

onready var jump_timer : Timer = $Timers/JumpTimer
onready var floor_timer : Timer = $Timers/FloorTimer
onready var ladder_timer : Timer = $Timers/LadderTimer
onready var platform_timer : Timer = $Timers/PlatformTimer
onready var sprite : Sprite = $Gunslinger
onready var anim : AnimationPlayer = $Gunslinger/AnimationPlayer
onready var state_machine: PlayerFSM = $PlayerStates
onready var tween : Tween = $Tween
onready var waves : Particles2D = $Waves

# Weapons
onready var gun_pivot : Position2D = $GunPivot
onready var gun1 : Sprite = $GunPivot/Gun1
onready var gun1_anim : AnimationPlayer = $GunPivot/Gun1/AnimationPlayer

# Attack
var attack_cooldown_time : int = 425
var next_attack_time = 0
var attack_damage = 30

func _ready():
	state_machine.init(self)
	Health.reset()

func _physics_process(_delta):
	update_inputs()
	update_player()
	state_machine.run()
	emit_signal("hud", "%s" % state_machine.active_state.tag)

func update_inputs():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		Global.goto_scene(Global.menu_scene)

	horizontal = (
		int(Input.is_action_pressed("ui_right"))
		- int(Input.is_action_pressed("ui_left"))
	)
	vertical = (
		int(Input.is_action_pressed("ui_down"))
		- int(Input.is_action_pressed("ui_up"))
	)
	up = Input.is_action_pressed("ui_up")
	if Input.is_action_pressed("shoot"):
		shoot()
	running = Input.is_action_pressed("run")
	if Input.is_action_just_pressed("ui_accept"):
		jump_timer.start()
	if is_on_floor():
		floor_timer.start()
		
func update_player():
	# Face player
	sprite.flip_h = flip
	
	# Face weapon and layer appropriately
	gun1.flip_v = flip
	gun_pivot.z_index = -1 if flip else 0
	gun_pivot.position.x = 2 if flip else -2

func move():
	var _old = velocity
	velocity = move_and_slide(velocity, Vector2.UP, true, 4, PI/4, false)

func apply_gravity(_gravity:float):
	velocity += Vector2.DOWN * _gravity

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
	var now = OS.get_ticks_msec()
	if now >= next_attack_time:
		var b = Bullet.instance()
		owner.add_child(b)
		b.shoot(get_global_mouse_position(), gun1.global_position)
		gun1_anim.play('shoot')
		next_attack_time = now + attack_cooldown_time
		yield(gun1_anim, "animation_finished")
		gun1_anim.play('idle')
	
func hit(damage):
	Health.take_damage(damage)

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
	
func _get_health():
	return Health._get_current_health()
###########################################################

func _on_PlatformTimer_timeout():
	collision_layer = 1 | 2

func _on_HurtBox_body_entered(body):
	if body.is_in_group('mobs'):
		Health.take_damage(body.attack_damage)
