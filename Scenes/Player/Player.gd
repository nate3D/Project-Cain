extends CharacterBody2D
class_name Player

signal hud

@export 
var gravity : float = 60

var Bullet : PackedScene = load("res://Scenes/Weapon/Gunslinger/RoundProjectile.tscn")
var Health2 = load("res://Scenes/Player/Health.tres")

var horizontal : int = 0
var vertical : int = 0
var up : bool = false
var vx: float = 0: get = _get_vx, set = _set_vx
var vy: float = 0: get = _get_vy, set = _set_vy

var underwater : bool = false
var running : bool = false
var grounded : bool = false: get = _get_grounded
var jumping : bool = false: get = _get_jumping
var ladder_area : bool = false
var ladder_tip : bool = false
var ladder_x : float
var flip : bool = false

@onready 
var jump_timer : Timer = $Timers/JumpTimer

@onready 
var floor_timer : Timer = $Timers/FloorTimer

@onready 
var ladder_timer : Timer = $Timers/LadderTimer

@onready 
var platform_timer : Timer = $Timers/PlatformTimer

@onready 
var sprite : Sprite2D = $Gunslinger

@onready 
var anim : AnimationPlayer = $Gunslinger/AnimationPlayer

@onready 
var state_machine: PlayerFSM = $PlayerStates

@onready 
var waves : GPUParticles2D = $Waves

# Weapons
@onready var gun_pivot : Marker2D = $GunPivot
@onready var gun1 : Sprite2D = $GunPivot/Gun1
@onready var gun1_anim : AnimationPlayer = $GunPivot/Gun1/AnimationPlayer

# Attack
var attack_cooldown_time : int = 425
var next_attack_time = 0
var attack_damage = 30

func _ready():
	state_machine.init(self)
	Health2.reset()

func _physics_process(_delta):
	update_inputs()
	update_player()
	state_machine.run()
	Global.emit_signal("Hud", "%s" % state_machine.active_state.tag)

func update_inputs():
	if Input.is_action_pressed("ui_cancel"):
		print("ESC Pressed")
		Global.emit_signal("PauseGame")

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
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	set_floor_stop_on_slope_enabled(true)
	set_max_slides(4)
	set_floor_max_angle(PI/4)
	# TODOConverter40 infinite_inertia were removed in Godot 4.0 - previous value `false`
	move_and_slide()
	velocity = velocity

func apply_gravity(_gravity:float):
	velocity += Vector2.DOWN * _gravity

func play(animation:String):
	if anim.current_animation == animation:
		return
	anim.play(animation)

func tween_to_ladder():
	var tween = create_tween()
	var target = Vector2(ladder_x, position.y)
	tween.interpolate_property(self, "position", position, target,
		0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func can_climb():
	return ladder_area and ladder_timer.is_stopped()
	
func shoot():
	var now = Time.get_ticks_msec()
	if now >= next_attack_time:
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.shoot(get_global_mouse_position(), gun1.global_position)
		gun1_anim.play('shoot')
		next_attack_time = now + attack_cooldown_time
		await gun1_anim.animation_finished
		gun1_anim.play('idle')
	
func hit(damage):
	Health2.take_damage(damage)

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
	return Health2._get_current_health()
###########################################################

func _on_PlatformTimer_timeout():
	collision_layer = 1 | 2

func _on_HurtBox_body_entered(body):
	if body.is_in_group('mobs'):
		Health2.take_damage(body.attack_damage)
