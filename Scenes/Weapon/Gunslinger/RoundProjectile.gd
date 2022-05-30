extends Area2D
class_name RoundProjectile

var speed = 1000
var direction = Vector2()
var attack_damage = 5

func shoot(aim_position, gun_position):
	global_position = gun_position
	direction = (aim_position - gun_position).normalized()
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * speed * delta

func _on_RoundProjectile_body_entered(body):
	if body is Player:
		return
		
	if body.is_in_group('mobs'):
		body.hit(attack_damage)
	queue_free()
