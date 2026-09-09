extends Node

var positions = []
var init_positions = [0, 0, 0, 0]

@onready var marker: Node2D = $Marker


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	positions = get_tree().get_nodes_in_group("Position Marker")
	
	if !OS.is_debug_build():
		for pm in positions:
			pm.visible = false
	
	init_positions[0] = $Projectile.position
	init_positions[1] = $Projectile2.position
	init_positions[2] = $Projectile3.position
	init_positions[3] = $Projectile4.position
	
	activate_projectiles()


#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.keycode == Key.KEY_R:
			#reset_projectiles()
		#elif event.keycode == Key.KEY_T:
			#activate_projectiles(4)


func reset_projectiles():
	$Projectile.set_linear = false
	$Projectile2.set_linear = false
	$Projectile3.set_linear = false
	$Projectile4.set_linear = false
	
	$Projectile.position = init_positions[0]
	$Projectile2.position = init_positions[1]
	$Projectile3.position = init_positions[2]
	$Projectile4.position = init_positions[3]


func activate_projectiles(num_of_projectiles = 0):
	match num_of_projectiles:
		1:
			$Projectile.set_linear = true
		2:
			$Projectile.set_linear = true
			$Projectile2.set_linear = true
		3:
			$Projectile.set_linear = true
			$Projectile2.set_linear = true
			$Projectile3.set_linear = true
		4:
			$Projectile.set_linear = true
			$Projectile2.set_linear = true
			$Projectile3.set_linear = true
			$Projectile4.set_linear = true
