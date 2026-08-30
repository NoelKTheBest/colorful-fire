extends RigidBody2D

#@export var max_speed = 100
#@export var acceleration = 20
#var speed : int
var prev_y_velocity: float
var current_y_velocity: float


func _process(delta: float) -> void:
	if prev_y_velocity > 0.0 and linear_velocity.y == 0.0:
		print("collide")
	
	prev_y_velocity = linear_velocity.y
	


func _on_timer_timeout() -> void:
	queue_free()


func _on_hot_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ground"):
		# spawn something else
		# update the position of something
		print("hit the flooor!!!")
		pass
