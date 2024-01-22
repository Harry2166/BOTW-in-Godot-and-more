extends RigidBody3D

@onready var mesh = $MeshInstance3D2
@onready var player = $"../../Player"
var direction = Vector3()
var become_magnetic = false
var magnetizedMaterial = StandardMaterial3D.new()
var normalMaterial = StandardMaterial3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	magnetizedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(0,0,0,1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if become_magnetic:
		position = position.lerp(player.position, 0.025)
		mesh.material_override = magnetizedMaterial
	else:
		mesh.material_override = normalMaterial
	
func go_to_magnet():
	become_magnetic = true
