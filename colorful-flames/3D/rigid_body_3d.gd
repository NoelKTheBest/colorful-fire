extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var body_id = get_rid()
	PhysicsServer3D.body_apply_central_impulse(body_id, Vector3(1, 3, 9))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	# Set the position to the opposite on a particular axis 
	# or the opposite of the current velocity vector multiplied 
	# by 2 to reverse the direction instantly
	apply_central_impulse(Vector3.UP * 25 + Vector3(0.25, 0, -18))
