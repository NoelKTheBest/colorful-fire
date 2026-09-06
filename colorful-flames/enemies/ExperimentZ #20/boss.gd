extends AnimatedSprite2D

var attacking = false
var projectile = preload('res://projectile.gd')
var positions = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	positions = get_tree().get_nodes_in_group("Position Marker")
	
	if OS.is_debug_build():
		for pm in positions:
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
	new_orb.position = positions[0].position
	new_orb.set_linear = true
	new_orb.m = 4
	new_orb.reparent(get_parent())


func _on_shield_area_entered(area: Area2D) -> void:
	area.queue_free()


func _on_shield_body_entered(body: Node2D) -> void:
	body.queue_free()
