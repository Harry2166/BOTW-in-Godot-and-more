extends RigidBody3D

@onready var player = $"../../Player"
var direction = Vector3()
var become_magnetic = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if become_magnetic:
		position = position.lerp(player.position, 0.025)
		#direction = (player.position - position).normalized()
		#print(direction)
		
	
func go_to_magnet():
	become_magnetic = true
