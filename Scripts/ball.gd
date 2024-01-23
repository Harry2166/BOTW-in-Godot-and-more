extends RigidBody3D

@onready var player = $"../../Player"

func _physics_process(delta):
	if (sleeping and Input.is_action_just_pressed("cancel")) or not player.stop_obj:
		sleeping = false

func get_stopped():
	sleeping = true
