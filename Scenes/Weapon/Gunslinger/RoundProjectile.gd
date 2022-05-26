extends Area2D

var speed = 1000
var direction = Vector2()
onready var anim : AnimationPlayer = $Gun1/AnimationPlayer

func shoot(aim_position, gun_position):
	global_position = gun_position
	direction = (aim_position - gun_position).normalized()
	rotation = direction.angle()
	#anim.play('shoot')
	
func _physics_process(delta):
	position += direction * speed * delta

func _on_RoundProjectile_body_entered(body):
	if body.is_in_group("players"):
		return
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
	pass
