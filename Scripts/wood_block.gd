extends RigidBody3D

@onready var mesh = $MeshInstance3D
@onready var player = $"../../Player"
var direction = Vector3()
var got_wood = false
var magnetizedMaterial = StandardMaterial3D.new()
var normalMaterial = StandardMaterial3D.new()
var potentialMaterial = StandardMaterial3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	magnetizedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(0.251, 0.184, 0.114, 1)
	potentialMaterial.albedo_color = Color(1, 0.0784314, 0.576471, 1)

func _process(delta):
	if not player.use_wood:
		got_wood = false

func _integrate_forces(state):
	if Input.is_action_just_pressed("press") and got_wood and player.use_wood:
		state.linear_velocity = state.linear_velocity.lerp((position - player.position)*4, 0.1)
	
func _physics_process(delta):
	if got_wood and player.use_wood and player.crosshair.visible:
		mesh.material_override = magnetizedMaterial
	elif player.use_wood and not got_wood:
		mesh.material_override = potentialMaterial
	else:
		mesh.material_override = normalMaterial
	
func is_wood():
	got_wood = true
