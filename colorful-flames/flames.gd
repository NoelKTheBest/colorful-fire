extends AnimatedSprite2D

@export var max_speed = 100
@export var acceleration = 20
var speed : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = move_toward(speed, max_speed, acceleration)
	position.y += speed * delta
