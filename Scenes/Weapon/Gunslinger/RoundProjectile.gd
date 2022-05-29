extends Area2D
class_name RoundProjectile

var speed = 1000
var direction = Vector2()

func _init():
	z_index = 2

func shoot(aim_position, gun_position):
	global_position = gun_position
	direction = (aim_position - gun_position).normalized()
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * speed * delta

func _on_RoundProjectile_body_entered(body):
	if body is Player:
		return
	queue_free()
