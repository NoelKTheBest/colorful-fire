extends Area2D

@export var a = 0
@export var vector: Vector2
@export var r: float = 5
@export var circle_center: Vector2
@export_subgroup("Linear Controls")
@export var linear_speed = 5.0
@export_range(-1.5, 1.5) var linear_range = 0.0
@export var color = Color.ORANGE_RED

var x_multiplier
var y_multiplier
var m: float = 1
var time = 0.0
var x_offset
var y_offset

var set_quadratic
var set_cubic
var set_linear
var set_wave
## for use with wave and linear functions only
var set_horizontal_speed
var set_flames
var go_left := false
var flip_mult = 1
var move_to_pos : Vector2

var cubic_p = []
var quad_p = []
var lin_p = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x_offset = position.x
	y_offset = position.y
	cubic_p = get_tree().get_nodes_in_group("Cubic Points")
	quad_p = get_tree().get_nodes_in_group("Quadratic Points")
	lin_p = get_tree().get_nodes_in_group("Linear Points")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position.y = tan(vector.x) * multiplier+
	#position.y = sin(vector.x) * multiplier
	#position = circle(r) - not working
	#position.y = log(vector.x) / log(10)
	
	flip_mult = -1 if go_left else 1
	
	if set_flames: $BlueFlames.visible = true
	
	if set_wave:
		position.x = vector.y * x_multiplier + x_offset * flip_mult
		position.y = cos(vector.x) * y_multiplier + y_offset
		$Wave.visible = true
	
	if set_linear:
		var destination = (lin_p[0].position - position)
		var within_range_x = destination.x > -1.5 and destination.x < 1.5
		var within_range_y = destination.y > -1.5 and destination.y < 1.5
		if !within_range_x and !within_range_y:
			position += destination.normalized() * linear_speed
	
	if set_quadratic:
		position = _quadratic_bezier(quad_p[0].position, quad_p[1].position, quad_p[2].position, time)
		$Quadratic_Cubic.visible = true
	
	if set_cubic:
		position = _cubic_bezier(cubic_p[0].position, cubic_p[1].position, cubic_p[2].position, cubic_p[3].position, time)
		$Quadratic_Cubic.visible = true
	
	if set_wave or set_linear:
		vector.x += 0.1
		vector.y -= 0.1
	
	if set_quadratic or set_cubic:
		time += 0.01
		time = clamp(time, 0.0, 1.0)


func set_offset():
	x_offset = position.x
	y_offset = position.y
	print()


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


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	#print("I'm on screen :>  - ", vector, get_parent())
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
	pass


func _on_timer_timeout() -> void:
	#queue_free()
	pass
