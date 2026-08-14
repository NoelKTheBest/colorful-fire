extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0

@export var accel : int
@export var fire_spread_amount : int = 16
@export var fire_spread_wait : float = 0.2

var flames_spreading: bool = false
var coroutine_finished: bool = false
var fire_spawn_init_position: Vector2
var fsi: int

@onready var fire_scene = preload("res://flames.tscn")


func _ready() -> void:
	fire_spawn_init_position = $FireSpawnPosition.position


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"set_fire"):
		flames_spreading = true
		coroutine_finished = true
		$Timer.start()
	
	if flames_spreading and coroutine_finished:
		spawn_flames()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		velocity.x = move_toward(velocity.x, direction * SPEED, accel)
	else:
		velocity.x = move_toward(velocity.x, 0, accel)

	move_and_slide()


func spawn_flames():
	coroutine_finished = false
	
	var flames = fire_scene.instantiate()
	flames.position.x = fire_spawn_init_position.x + (fsi * fire_spread_amount)
	flames.position.y = fire_spawn_init_position.y
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
