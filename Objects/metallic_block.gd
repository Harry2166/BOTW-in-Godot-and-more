extends RigidBody3D
class_name Metal
@onready var mesh = $MeshInstance3D
@onready var player = $"../../Player"
var direction = Vector3()
var become_magnetic = false
var magnetizedMaterial = StandardMaterial3D.new()
var normalMaterial = StandardMaterial3D.new()
var potentialMaterial = StandardMaterial3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	magnetizedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(0,0,0,1.0)
	potentialMaterial.albedo_color = Color(1, 0.0784314, 0.576471, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player.is_magnet:
		become_magnetic = false
	
func _physics_process(delta):
	if become_magnetic and player.is_magnet:
		position = position.lerp(player.position, 0.025)
		mesh.material_override = magnetizedMaterial
	elif player.is_magnet:
		mesh.material_override = potentialMaterial
	else:
		mesh.material_override = normalMaterial
	
func go_to_magnet():
	become_magnetic = true
