extends AnimatedSprite2D

var attacking = false
var projectile = preload('res://enemies/projectiles/projectile.tscn')
var positions = []
var player_position
var multipliers = [Vector2(25, 100), Vector2(250, 50)]
var toggle = 0
var health = 100
var current_frame = 0
var was_hit = false
var dying = false

var pos_pattern = 0
var proj_pattern = 0
var move_pattern = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	positions = get_tree().get_nodes_in_group("Position Marker")
	
	if OS.is_debug_build():
		for pm in positions:
			pm.visible = false
	
	$CanvasLayer/ProgressBar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flip_h = true if SceneVariables.player_position.x < position.x else false 
	$CanvasLayer/ProgressBar.value = health
	
	if $Shield.has_overlapping_areas():
		var areas = $Shield.get_overlapping_areas()
		if areas[0].visible:
			if !areas[0].is_in_group("Player Attack"): 
				if areas[0].is_in_group("Flames"):
					health -= 1
				else:
					areas[0].queue_free()
			else:
				if !was_hit:
					health -= 3
					was_hit = true
					$DamageTimer.start()



func _on_animation_finished() -> void:
	if !dying: 
		play(&'default')
		current_frame = 0
	elif dying: queue_free()


func _on_attack_timer_timeout() -> void:
	play(&'attack')
	attacking = true
	$ProjectileWait.start()


func _on_projectile_wait_timeout() -> void:
	toggle_hitbox()
	var new_orb = projectile.instantiate()
	var pp = get_tree().get_first_node_in_group("Player").position
	#print(pp)
	
	new_orb.position = positions[pos_pattern].position
	add_child(new_orb)
	new_orb.reparent(get_parent())
	new_orb.set_offset()
	match proj_pattern:
		0:
			new_orb.set_wave = true
		1: 
			new_orb.set_quadratic = true
		2:
			new_orb.set_cubic = true
	var flip = 1 if flip_h else -1
	new_orb.x_multiplier = multipliers[toggle].x * flip
	new_orb.y_multiplier = multipliers[toggle].y
	toggle = 1 - toggle
	
	pos_pattern += 1
	
	if pos_pattern > positions.size() - 1: 
		pos_pattern = 0
		proj_pattern += 1


func toggle_hitbox():
	$Area2D.visible = true
	$Area2D2.visible = true
	
	await get_tree().create_timer(0.25).timeout
	$Area2D.visible = false
	$Area2D2.visible = false


func _on_shield_area_entered(area: Area2D) -> void:
	if area.visible:
		if !area.is_in_group("Player Attack"): area.queue_free()
		else:
			if !was_hit:
				health -= 3

				was_hit = true


func _on_shield_body_entered(body: Node2D) -> void:
	body.queue_free()


func _on_frame_changed() -> void:
	if attacking:
		#print(current_frame)
		current_frame += 1


func die():
	play(&'die')
	dying = true


func _on_damage_timer_timeout() -> void:
	was_hit = false
