extends Position2D

var direction = Vector2()

func _ready():
	pass # Replace with function body.

func _process(_delta):
	look_at(get_global_mouse_position())
