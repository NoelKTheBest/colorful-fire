extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	apply_central_impulse(Vector3.UP * 25 + Vector3(0.25, 0, 2))
