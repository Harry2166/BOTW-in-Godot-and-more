extends RigidBody3D
@onready var player = $"./../Player"
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if player.ice_ice_tubig and Input.is_action_just_pressed("cancel") and player.aim_ray.get_collider() == self:
		player.cryo_blocks -= 1
		queue_free()
