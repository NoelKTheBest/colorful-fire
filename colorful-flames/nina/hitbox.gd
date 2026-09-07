extends Area2D

signal player_hit_boss
var can_signal_again


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	if areas.size() > 0 and can_signal_again:
		player_hit_boss.emit()
		can_signal_again = false
