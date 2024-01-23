extends RigidBody3D

@onready var player = $"../../Player"
@onready var mesh = $MeshInstance3D
@onready var timer = $Timer

var is_sleeping = false

var stopMaterial = StandardMaterial3D.new()
var normalMaterial = StandardMaterial3D.new()

func _ready():
	stopMaterial.albedo_color = Color(0.721569, 0.52549, 0.0431373, 1)
	normalMaterial.albedo_color = Color(1, 0.027, 1)

func _physics_process(delta):
	if (is_sleeping and Input.is_action_just_pressed("cancel")) or not player.stop_obj:
		sleeping = false
		is_sleeping = false
	if is_sleeping and player.stop_obj:
		mesh.material_override = stopMaterial
	else:
		mesh.material_override = normalMaterial
		is_sleeping = false

func get_stopped():
	sleeping = true
	is_sleeping = true
	timer.start()
	
func _on_timer_timeout():
	is_sleeping = false
	sleeping = false
	print("IM OUT")
