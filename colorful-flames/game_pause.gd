extends CanvasLayer

var tuto_finished = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tuto_finished:
		if Input.is_action_just_pressed(&'pause'):
			get_tree().paused = !get_tree().paused
		
		visible = true if get_tree().paused else false


func _on_tutorial_tutorial_finished() -> void:
	tuto_finished = true
