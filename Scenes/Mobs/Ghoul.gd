extends RigidBody2D

onready var anim_sprite : AnimatedSprite = $AnimatedSprite

export var damage = 5

func _ready():
	anim_sprite.playing = true
	anim_sprite.play('idle')
	yield(anim_sprite, "animation_finished")
	anim_sprite.play('walk')

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
