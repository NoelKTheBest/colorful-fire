extends AnimatedSprite2D

var attacking = false
var projectile = preload('res://projectile.gd')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.is_debug_build():
		for pm in get_tree().get_nodes_in_group("Position Marker"):
			pm.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flip_h = true if SceneVariables.player_position.x < position.x else false 


func _on_animation_finished() -> void:
	play(&'default')


func _on_attack_timer_timeout() -> void:
	play(&'attack')
	$ProjectileWait.start()


func _on_projectile_wait_timeout() -> void:
	var new_orb = projectile.new()
	new_orb.position
