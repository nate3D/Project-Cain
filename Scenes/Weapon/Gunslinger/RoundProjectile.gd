extends Area2D

var speed = 1000
var direction = Vector2()
onready var mouse_pos = null

func _ready():
	mouse_pos = get_local_mouse_position()

func shoot(aim_position, gun_position):
	global_position = gun_position
	direction = (aim_position - gun_position).normalized()
	rotation = direction.angle()
	
func _physics_process(delta):
	position += direction * speed * delta
	
#func _physics_process(delta):
#	movement = movement.move_toward(mouse_pos, delta)
#	movement = movement.normalized() * speed
#	position = position + movement

func _on_RoundProjectile_body_entered(body):
	if body.is_in_group("players"):
		return
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
	pass
