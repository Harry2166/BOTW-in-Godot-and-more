extends RigidBody3D
@onready var player = $"../../Player"
@onready var level = $"."
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	freeze = true

func _process(delta):
	
	if not player.bomb_guy:
		queue_free()
	
	if (player.bomb_objs == 0 and Input.is_action_just_pressed("A") and player.bomb_guy):
		print("boom")
		queue_free()
		player.bomb_objs = 1
		player.bomb_spawned = false
		
	elif (player.bomb_objs == 0 and Input.is_action_just_pressed("cancel") and player.bomb_guy):
		print("im out")
		queue_free()
		player.bomb_objs = 1
		player.bomb_spawned = false

func get_thrown(impulse):
	player.bomb_objs = 0
	player.bomb_spawned = false
	var position_to_be_placed = Vector3(player.global_position.x, player.global_position.y + 10, player.global_position.z)
	#apply_central_impulse(impulse)
	#print(self)
	#print(player.global_position)
	#player.remove_child(self)
	#level.add_child(self)
	print(position_to_be_placed)
	set_position(position_to_be_placed)
	print(global_position)
	
