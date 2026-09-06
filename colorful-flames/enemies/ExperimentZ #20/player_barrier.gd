extends StaticBody2D

@export var radius = 10.0
@export var width = 1.0
@export var color = Color.BLUE


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_circle(position, radius, color, false, width)
