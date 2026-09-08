extends CanvasLayer

signal tutorial_finished
var tuto_step = 1

var tuto_text = [
	"Hello, and welcome to my game! My name is Nina and I need your help to defeat this evil demon ⏎ (Enter)",
	"You can use WASD to move, but first use the space bar ⎵ to jump!",
	"You can also use space ⎵ and press down ↓ to drop through the platforms ⏎",
	"I can attack with J and use my fire ability with F",
	"Lastly, I can use my dodge ability to avoid damage with the U key",
	"To pause or see the controls again, press ESC ⏎",
	"Now, let's kick some butt! ⏎"
]


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_UNPAUSED:
			if tuto_step == 1: $AnimationPlayer.play(&'text_scroll')
			
			#if tuto_step == 7:
				#$Controls.visible = 


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and get_tree().paused:
		match tuto_step:
			1:
				if event.keycode == Key.KEY_ENTER:
					$Label.text = tuto_text[tuto_step]
					$AnimationPlayer.play(&'text_scroll')
					tuto_step += 1
			2:
				if event.keycode == Key.KEY_SPACE:
					get_tree().paused = false
					$TutoTimer.start()
					tuto_step += 1
					# Wait for pause again before we advance the text
			3:
				if event.keycode == Key.KEY_ENTER:
					$Label.text = tuto_text[tuto_step]
					$AnimationPlayer.play(&'text_scroll')
					tuto_step += 1
			4:
				if event.keycode == Key.KEY_J or event.keycode == Key.KEY_F:
					$Label.text = tuto_text[tuto_step]
					get_tree().paused = false
					$TutoTimer.start()
					$AnimationPlayer.play(&'text_scroll')
					tuto_step += 1
			5:
				if event.keycode == Key.KEY_U:
					$Label.text = tuto_text[tuto_step]
					get_tree().paused = false
					$TutoTimer.start()
					$AnimationPlayer.play(&'text_scroll')
					tuto_step += 1
			6:
				if event.keycode == Key.KEY_ENTER:
					$Label.text = tuto_text[tuto_step]
					$AnimationPlayer.play(&'text_scroll')
					tuto_step += 1
			7:
				if event.keycode == Key.KEY_ENTER:
					get_tree().paused = false
					tutorial_finished.emit()


func _on_tuto_timer_timeout() -> void:
	# on ready tuto_step = 1
	# advance once and use tuto_step == 1 before incrementing
	# tuto_step ==? 2
	get_tree().paused = true
	$Label.visible = true
	$Label.text = tuto_text[tuto_step - 1]
