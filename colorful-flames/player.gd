extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0

@export var accel : int
@export var fire_spread_amount : int = 16
@export var fire_spread_wait : float = 0.2
@export var fall_velocity_factor : float = 3

var flames_spreading: bool = false
var coroutine_finished: bool = false
var fire_spawn_init_position: Vector2
var fire_spawn_origin: Vector2
var fire_spread_direction: int
var fsi: int

@onready var fire_scene = preload("res://flames.tscn")
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	fire_spawn_init_position = $FireSpawnPosition.position
	fire_spawn_origin = $FireSpawnPosition.position


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"set_fire"):
		flames_spreading = true
		coroutine_finished = true
		$Timer.start()
	
	if flames_spreading and coroutine_finished:
		spawn_flames()


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
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, accel)
		sprite_2d.flip_h = true if direction < 0 else false
	else:
		velocity.x = move_toward(velocity.x, 0, accel)
	
	fire_spread_direction = -1 if sprite_2d.flip_h else 1
	$FireSpawnPosition.position.x = -fire_spawn_init_position.x if sprite_2d.flip_h else fire_spawn_init_position.x
	if $Timer.time_left == 0: fire_spawn_origin = $FireSpawnPosition.position

	move_and_slide()


func spawn_flames():
	coroutine_finished = false
	
	var flames = fire_scene.instantiate()
	flames.position.x = fire_spawn_origin.x + (fsi * fire_spread_amount * fire_spread_direction)
	flames.position.y = fire_spawn_origin.y
	add_child(flames)
	var mother = get_parent()
	# Defer call since new nodes cannot get added to parent until all child nodes have been accounted for
	# instantiating a child of this object is easy because the engine starts with the bottom-most children first
	#flames.reparent.call_deferred(mother)
	flames.reparent(mother)
	await get_tree().create_timer(fire_spread_wait).timeout
	
	coroutine_finished = true
	fsi += 1


func _on_timer_timeout() -> void:
	flames_spreading = false
	coroutine_finished = false
	fsi = 0
	fire_spawn_origin = $FireSpawnPosition.position
