extends CanvasLayer

export (Resource) var Health

onready var health_label = $Health

func _ready():
	if Health:
		Health.connect("health_changed", self, "_on_player_health_changed")
		health_label.text = str(Health.max_value)
		
func _on_player_health_changed(value):
	health_label.text = str(float(value) / Health.max_value * 100)

func set_text(text):
	$Label.text = str(text)


