extends CanvasLayer

export (Resource) var Health

onready var healthbar = $HealthBar

func _ready():
	if Health:
		Health.CONNECT_DEFERRED("health_changed", self, "_on_player_health_changed")
		
func _on_player_health_changed(value):
	healthbar.value = float(value) / Health.max_value * 100

func set_text(text):
	$Label.text	= str(text)


