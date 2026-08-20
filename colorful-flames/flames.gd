extends RigidBody2D

#@export var max_speed = 100
#@export var acceleration = 20
#var speed : int


func _on_timer_timeout() -> void:
	queue_free()
