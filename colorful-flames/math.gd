extends Sprite2D

@export var a = 0
@export var vector: Vector2
@export var multiplier = 25
@export var m: float = 1
@export var r: float = 5
var time = 0.0
var x_offset
var y_offset


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x_offset = position.x
	y_offset = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#position.x = vector.y * multiplier + x_offset
	#position.y = cos(vector.x) * multiplier + y_offset
	#position.y = sin(vector.x) * multiplier
	#position.y = tan(vector.x) * multiplier
	#position.y = slope(m, vector.x, 0) * multiplier
	#position = circle(r) - not working
	#position = _quadratic_bezier($'../Node2D'.position, $'../Node2D2'.position, $'../Node2D3'.position, time)
	#position.y = log(vector.x) / log(10)
	position = _cubic_bezier($'../Node2D'.position, $'../Node2D2'.position, $'../Node2D3'.position, $'../Node2D4'.position, time)
	
	time += 0.01
	time = clamp(time, 0.0, 1.0)
	vector.x += 0.1
	vector.y += 0.1


func slope(m: float, time: float, b: float):
	return (m * time) + b



func circle(radius: float):
	var x = radius - (vector.y - y_offset) + x_offset
	var y = radius - (vector.x - x_offset) + y_offset
	return Vector2(x, y)


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	
	var rr = q0.lerp(q1, t)
	return rr


func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)
	
	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)
	
	var s = r0.lerp(r1, t)
	return s
