extends Resource
class_name Health

signal health_changed(current_value)
signal health_zero

export (int) var max_value setget ,_get_max_health
export (int) var current_value setget ,_get_current_health

func reset():
	current_value = max_value
	
func take_damage(amount):
	current_value = max(0, current_value - amount)
	emit_signal("health_changed", current_value)
	if current_value <= 0:
		current_value = 0
		emit_signal("health_zero")
	
func heal(amount):
	current_value = min(max_value, current_value + amount)
	emit_signal("health_changed", current_value)

func _get_max_health():
	return max_value
	
func _get_current_health():
	return current_value
