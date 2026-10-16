extends Camera3D

@onready var main_look_obj = $"../RigidBody3D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var logp = main_look_obj.global_position
	var _lolp = main_look_obj.position
	look_at(logp)
