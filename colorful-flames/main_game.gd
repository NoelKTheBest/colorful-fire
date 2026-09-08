extends Node

var viewport
var wait_for_tuto = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cubi in $CubicPoints.get_children():
		cubi.visible = false
	
	for quad in $QuadraticPoints.get_children():
		quad.visible = false
	#$Camera2D.make_current()
	
	viewport = get_viewport()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _shortcut_input(event: InputEvent) -> void:
	if wait_for_tuto: viewport.set_input_as_handled()


func _on_boss_ult_notify() -> void:
	pass # Replace with function body.


func _on_boss_boss_attacking() -> void:
	pass # Replace with function body.


func _on_tuto_timer_timeout() -> void:
	wait_for_tuto = false
