extends RigidBody3D
@onready var player = $"../../Player"
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	freeze = true

func _process(delta):
	if (player.bomb_objs == 0 and Input.is_action_just_pressed("A") and player.bomb_guy):
		queue_free()
		player.bomb_objs = 1
		player.bomb_spawned = false
