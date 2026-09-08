extends Node

var viewport
var wait_for_tuto = true
var tuto_finished = false


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
	if Input.is_action_just_pressed(&'pause'):
		get_tree().paused = true

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PAUSED:
			if tuto_finished:
				$Tutorial/Controls.visible = true
				$Tutorial/Label.visible = false
		NOTIFICATION_UNPAUSED:
			if tuto_finished:
				$Tutorial/Controls.visible = false
				$Tutorial/Label.visible = false


func _shortcut_input(event: InputEvent) -> void:
	if wait_for_tuto: viewport.set_input_as_handled()


func _on_boss_ult_notify() -> void:
	pass # Replace with function body.


func _on_boss_boss_attacking() -> void:
	pass # Replace with function body.


func _on_tuto_timer_timeout() -> void:
	wait_for_tuto = false


func _on_tutorial_tutorial_finished() -> void:
	tuto_finished = true
