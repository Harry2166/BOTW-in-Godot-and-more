extends RigidBody3D
class_name Wood
@onready var mesh = $MeshInstance3D
@onready var player = $"../../Player"
@onready var timer = $Timer
@onready var stasis_component = $StasisComponent
var direction = Vector3()
var become_usable = false
var grabbedMaterial = StandardMaterial3D.new()
var normalMaterial = StandardMaterial3D.new()
var potentialMaterial = StandardMaterial3D.new()
var stopMaterial = StandardMaterial3D.new()
var go_to_this_point = Vector3()
var contained = false
var is_sleeping = false
var accumulation = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	grabbedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(0.251, 0.184, 0.114)
	potentialMaterial.albedo_color = Color(1, 0.0784314, 0.576471, 1)
	stopMaterial.albedo_color = Color(0.721569, 0.52549, 0.0431373, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("A") and player.use_wood and become_usable:
		contained = true
		
	elif Input.is_action_just_released("cancel"):
		contained = false
		become_usable = false
	
	if not player.use_wood:
		become_usable = false
		contained = false
	
func _physics_process(delta):
	if become_usable and player.use_wood and contained:
		mesh.material_override = grabbedMaterial
		go_to_this_point = Vector3(player.wood_location.global_position.x,player.wood_location.global_position.y, player.wood_location.global_position.z)
		position = position.lerp(go_to_this_point, 0.025)
	elif player.use_wood:
		mesh.material_override = potentialMaterial
	elif is_sleeping and player.stop_obj and stasis_component.is_sleeping:
		set_collision_mask_value(5,true)
		set_collision_layer_value(5,true)
		mesh.material_override = stopMaterial
	else:
		mesh.material_override = normalMaterial
		is_sleeping = false
		
	if (is_sleeping and Input.is_action_just_pressed("cancel")) or not player.stop_obj:
		is_sleeping = false
		freeze = false
		set_collision_mask_value(5,false)
		set_collision_layer_value(5,false)
		player.stopped_objs = 1
		
func get_used():
	become_usable = true

func _on_body_exited(body):
	become_usable = false

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	become_usable = false

func get_stopped():
	stasis_component.get_stopped()
