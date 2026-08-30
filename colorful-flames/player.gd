extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const DODGE_VELOCITY = 150

@export var accel : int
@export var fire_spread_amount : int = 16
@export var fire_spread_wait : float = 0.2
@export var fall_velocity_factor : float = 3
@export var health = 10
@export var dodge_speed_boost_init_value = 1.5

var flames_spreading: bool = false
var coroutine_finished: bool = false
var fire_spawn_init_position: Vector2
var fire_spawn_origin: Vector2
var fire_spread_direction: int
var fsi: int
var current_main_color := ""
var secondary_color := ""
var close_to_flames := false
var dodging := false
var attacking := false
var blocking := false
var ability_activated := false
var dodge_speed_boost : float
var hitbox_init_position : Vector2
var init_dodge_direction = 0

@onready var fire_scene = preload("res://flames.tscn")
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	fire_spawn_init_position = $FireSpawnPosition.position
	fire_spawn_origin = to_global($FireSpawnPosition.position)
	print($FireSpawnPosition.position)
	print(to_global($FireSpawnPosition.position))
	print(fire_spawn_origin)
	$AnimationTree.active = true
	hitbox_init_position = $Hitbox.position


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"set_fire"):
		flames_spreading = true
		coroutine_finished = true
		$Timer.start()
	
	if flames_spreading and coroutine_finished:
		spawn_flames()
	
	if Input.is_action_just_pressed(&'activate_secondary_ability'):
		ability_activated = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity += get_gravity() * fall_velocity_factor * delta
		else:
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if jump_buffer_timer.time_left > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer.stop()
	
	# Check to see if player has just pressed the dodge button and is not currently dodging
	if Input.is_action_just_pressed(&'dodge') and !dodging:
		dodging = true
		$AnimationPlayer.speed_scale = 3.0
	
	# Set the dodge speed boost based on a configurable variable
	dodge_speed_boost = dodge_speed_boost_init_value if dodging else 1.0
	
	# Get the input direction and handle the movement/deceleration
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		# init_dodge_direction will always be 0 before a dodge has started
		if dodging and init_dodge_direction == 0:
			init_dodge_direction = direction
		
		velocity.x = move_toward(velocity.x, direction * SPEED, accel)
		sprite_2d.flip_h = true if direction < 0 else false
	else:
		if dodging and init_dodge_direction == 0:
			# set init_dodge_direction to a non zero value
			init_dodge_direction = -1 if sprite_2d.flip_h else 1
		
		velocity.x = move_toward(velocity.x, 0, accel)
	
	# If the player is dodging, the velocity gets overridden by this code
	if dodging and init_dodge_direction != 0:
		velocity.x = DODGE_VELOCITY * init_dodge_direction
	
	$FireSpawnPosition.position.x = -fire_spawn_init_position.x if sprite_2d.flip_h else fire_spawn_init_position.x
	$Hitbox.position.x = -hitbox_init_position.x if sprite_2d.flip_h else hitbox_init_position.x
	
	if $Timer.time_left == 0:
		fire_spawn_origin = to_global($FireSpawnPosition.position)
		fire_spread_direction = -1 if sprite_2d.flip_h else 1
	
	move_and_slide()
	
	SceneVariables.player_position = position
	


#func _unhandled_input(event: InputEvent) -> void:
	#pass


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed(&'set_color_red'):
			current_main_color = "red"
			$Polygon2D.color = Color.DARK_RED
		elif event.is_action_pressed(&'set_color_blue'):
			current_main_color = "blue"
			$Polygon2D.color = Color.BLUE
		elif event.is_action_pressed(&'set_color_green'):
			current_main_color = "green"
			$Polygon2D.color = Color.LIME_GREEN
		elif event.is_action_pressed(&'set_color_yellow'):
			current_main_color = "yellow"
			$Polygon2D.color = Color.YELLOW
		elif event.is_action_pressed(&'set_color_orange'):
			current_main_color = "orange"
			$Polygon2D.color = Color.ORANGE
		elif event.is_action_pressed(&'set_color_cyan'):
			current_main_color = "cyan"
			$Polygon2D.color = Color.CYAN
		elif event.is_action_pressed(&'set_color_magenta'):
			current_main_color = "magenta"
			$Polygon2D.color = Color.MAGENTA
		elif event.is_action_pressed(&'set_color_white'):
			current_main_color = "white"
			$Polygon2D.color = Color.WHITE
		elif event.is_action_pressed(&'set_color_black'):
			current_main_color = "black"
			$Polygon2D.color = Color.BLACK
		var key_name = OS.get_keycode_string(event.key_label)
		print(key_name, "; pressed?: ", event.pressed)
		
		#match key_name: 
			#"Kp 5":
				#current_main_color = "red"
				#$Polygon2D.color = Color.DARK_RED
			#"Kp 8":
				#current_main_color = "blue"
				#$Polygon2D.color = Color.BLUE
			#"Kp 2":
				#current_main_color = "green"
				#$Polygon2D.color = Color.LIME_GREEN
			#"Kp 4":
				#current_main_color = "yellow"
				#$Polygon2D.color = Color.YELLOW
			#"Kp 6":
				#current_main_color = "orange"
				#$Polygon2D.color = Color.ORANGE
			#"Kp 7":
				#current_main_color = "cyan"
				#$Polygon2D.color = Color.CYAN
			#"Kp 9":
				#current_main_color = "magenta"
				#$Polygon2D.color = Color.MAGENTA
			#"Kp 1":
				#current_main_color = "white"
				#$Polygon2D.color = Color.WHITE
			#"Kp 3":
				#current_main_color = "black"
				#$Polygon2D.color = Color.BLACK


func spawn_flames():
	coroutine_finished = false
	
	var flames = fire_scene.instantiate()
	flames.position.x = fire_spawn_origin.x + (fsi * fire_spread_amount * fire_spread_direction)
	flames.position.y = fire_spawn_origin.y
	print(fire_spawn_origin)
	add_child(flames)
	var mother = get_parent()
	# Defer call since new nodes cannot get added to parent until all child nodes have been accounted for
	# instantiating a child of this object is easy because the engine starts with the bottom-most children first
	#flames.reparent.call_deferred(mother)
	flames.reparent(mother, false)
	await get_tree().create_timer(fire_spread_wait).timeout
	
	coroutine_finished = true
	fsi += 1


func die():
	queue_free()


func _on_timer_timeout() -> void:
	flames_spreading = false
	coroutine_finished = false
	fsi = 0
	fire_spawn_origin = to_global($FireSpawnPosition.position)
	print(fire_spawn_origin)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if !dodging:
		health -= 1
	
	if health <= 0:
		die()


func _on_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_fire_interact_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Flames"):
		close_to_flames = true


func _on_fire_interact_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Flames"):
		close_to_flames = false


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dodge":
		dodging = false
		init_dodge_direction = 0
		$AnimationPlayer.speed_scale = 1.0
