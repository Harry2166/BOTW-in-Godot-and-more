extends RigidBody3D

@onready var player = $"../../Player"
@onready var mesh = $MeshInstance3D
@onready var timer = $Timer

var is_sleeping = false
var accumulation = Vector3.ZERO

var stopMaterial = StandardMaterial3D.new()
var normalMaterial = StandardMaterial3D.new()

func _ready():
	stopMaterial.albedo_color = Color(0.721569, 0.52549, 0.0431373, 1)
	normalMaterial.albedo_color = Color(1, 0.027, 1)

func _physics_process(delta):
	if (is_sleeping and Input.is_action_just_pressed("cancel")) or not player.stop_obj:
		freeze = false
		is_sleeping = false
		player.stopped_objs = 1
	if is_sleeping and player.stop_obj:
		set_collision_mask_value(5,true)
		set_collision_layer_value(5,true)
		mesh.material_override = stopMaterial
	else:
		mesh.material_override = normalMaterial
		is_sleeping = false
		freeze = false
		set_collision_layer_value(5,false)
		set_collision_mask_value(5,false)

func get_stopped():
	is_sleeping = true
	freeze = true
	timer.start()
	
func _on_timer_timeout():
	is_sleeping = false
	freeze = false
	player.stopped_objs = 1
	hit(player.collision_point, player.hit_amount)
	
func hit(collision_point, hit_amount):
	var direction = (global_transform.origin - collision_point).normalized()
	var magnitude = accumulation.length() + hit_amount
	accumulation = direction * magnitude
	apply_central_impulse(accumulation)
	accumulation = Vector3.ZERO
