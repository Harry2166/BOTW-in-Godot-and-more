extends RigidBody3D
class_name Metal
@onready var mesh = $MeshInstance3D
@onready var player = $"../../Player"
var direction = Vector3()
var become_magnetic = false
var magnetizedMaterial = StandardMaterial3D.new()
var normalMaterial = StandardMaterial3D.new()
var potentialMaterial = StandardMaterial3D.new()
var stopMaterial = StandardMaterial3D.new()
var polarity = false
var going_away = Vector3()
var is_sleeping = false
var accumulation = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	magnetizedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(0,0,0,1.0)
	potentialMaterial.albedo_color = Color(1, 0.0784314, 0.576471, 1)
	stopMaterial.albedo_color = Color(0.721569, 0.52549, 0.0431373, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player.is_magnet or position.distance_to(player.position) > 7.5:
		become_magnetic = false
	
func _physics_process(delta):
	if become_magnetic and player.is_magnet:
		if polarity != player.player_polarity:
			position = position.lerp(player.position, 0.025)
		else:
			going_away = Vector3(-player.velocity.x, position.y, -player.velocity.z)
			position = position.lerp(-player.position, 0.025)
		mesh.material_override = magnetizedMaterial
	elif player.is_magnet:
		mesh.material_override = potentialMaterial
	elif is_sleeping and player.stop_obj:
		mesh.material_override = stopMaterial
	else:
		mesh.material_override = normalMaterial
		set_collision_mask_value(5,true)
		set_collision_layer_value(5,true)
		is_sleeping = false
		
	if (is_sleeping and Input.is_action_just_pressed("cancel")) or not player.stop_obj:
		is_sleeping = false
		sleeping = false
		player.stopped_objs = 1
		set_collision_mask_value(5,false)
		set_collision_layer_value(5,false)
	
func go_to_magnet():
	become_magnetic = true
	
func get_stopped():
	is_sleeping = true
	freeze = true
	$Timer.start()
	
func _on_timer_timeout():
	is_sleeping = false
	freeze = false
	player.stopped_objs = 1
	hit(player.collision_point, player.hit_amount)
	player.hit_amount = 0
	
func hit(collision_point, hit_amount):
	var direction = (global_transform.origin - collision_point).normalized()
	var magnitude = accumulation.length() + hit_amount
	accumulation = direction * magnitude
	apply_central_impulse(accumulation)
	accumulation = Vector3.ZERO
