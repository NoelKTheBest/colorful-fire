extends Node

var viewport
var wait_for_tuto = true
var tuto_finished = false
var ri = 0
@export var rm = 10
var rm_init
var prepping_ult = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cubi in $CubicPoints.get_children():
		cubi.visible = false
	
	for quad in $QuadraticPoints.get_children():
		quad.visible = false
	#$Camera2D.make_current()
	
	viewport = get_viewport()
	rm_init = rm


func _process(delta: float) -> void:
	if prepping_ult:
		if ri % rm == 0:
			$DangerRing.visible = !$DangerRing.visible
			rm -= 1
			rm = clampi(rm, 1, 1000000)
		
		ri += 1
		
		$DangerRing.position = $CharacterBody2D.position
	else:
		ri = 0
		rm = rm_init
		$DangerRing.visible = false


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PAUSED:
			if tuto_finished:
				$GamePause/Controls.visible = true
				$Tutorial/Label.visible = false
		NOTIFICATION_UNPAUSED:
			if tuto_finished:
				$GamePause/Controls.visible = false
				$Tutorial/Label.visible = false


func _shortcut_input(event: InputEvent) -> void:
	if wait_for_tuto: viewport.set_input_as_handled()


func _on_boss_ult_notify() -> void:
	prepping_ult = true


func _on_boss_boss_attacking() -> void:
	pass # Replace with function body.


func _on_tuto_timer_timeout() -> void:
	wait_for_tuto = false


func _on_tutorial_tutorial_finished() -> void:
	tuto_finished = true
	$Tutorial/Label.visible = false


func _on_boss_boss_died() -> void:
	$'You WIN/WINNER'.visible = true
	$GameWinTimer.start()


func _on_game_win_timer_timeout() -> void:
	get_tree().quit()


func _on_boss_ult_activated() -> void:
	prepping_ult = false
