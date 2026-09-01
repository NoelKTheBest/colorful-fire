extends Area2D

@export var a = 0
@export var vector: Vector2
@export var multiplier = 25
@export var m: float = 1
@export var r: float = 5
@export var circle_center: Vector2
var time = 0.0
var x_offset
var y_offset

var set_quadratic
var set_cubic
var set_linear
var set_wave
## for use with wave and linear functions only
var set_horizontal_speed



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x_offset = position.x
	y_offset = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position.y = tan(vector.x) * multiplier
	#position.y = sin(vector.x) * multiplier
	#position = circle(r) - not working
	#position.y = log(vector.x) / log(10)
	
	if set_wave:
		position.x = vector.y * multiplier + x_offset
		position.y = cos(vector.x) * multiplier + y_offset
	
	if set_linear:
		position.x = vector.y * multiplier + x_offset
		position.y = slope(m, vector.x, 0) * multiplier
	
	if set_quadratic:
		position = _quadratic_bezier($'../Node2D'.position, $'../Node2D2'.position, $'../Node2D3'.position, time)
	
	if set_cubic:
		position = _cubic_bezier($'../Node2D'.position, $'../Node2D2'.position, $'../Node2D3'.position, $'../Node2D4'.position, time)


func slope(mm: float, ttime: float, b: float):
	return (mm * ttime) + b


func circle(radius: float, center_x: float, center_y: float, current_x: float):
	return 2 + sqrt(radius - pow(current_x - center_x, 2.0))
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
