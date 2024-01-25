extends RigidBody3D
class_name Pickable
#@onready var player = $"../../Player"
#@onready var level = $"."
# Called every frame. 'delta' is the elapsed time since the previous frame.

var target = null

func _ready():
	#freeze = true
	add_to_group("pickable")

func _process(delta):
	if target != null:
		self.global_transform.origin = target.global_transform.origin
		self.global_transform.basis = target.global_transform.basis
	#if not player.bomb_guy:
		#queue_free()
	#
	#if (player.bomb_objs == 0 and Input.is_action_just_pressed("A") and player.bomb_guy):
		#print("boom")
		#queue_free()
		#player.bomb_objs = 1
		#player.bomb_spawned = false
		#
	#elif (player.bomb_objs == 0 and Input.is_action_just_pressed("cancel") and player.bomb_guy):
		#print("im out")
		#queue_free()
		#player.bomb_objs = 1
		#player.bomb_spawned = false
		
func _physics_process(delta):
	pass

func get_thrown(impulse):
	pass
	#player.bomb_objs = 0
	#player.bomb_spawned = false
	#var position_to_be_placed = Vector3(player.global_position.x + 2, player.bomb_location.global_position.y + 2, player.global_position.z + 2)
	#self.global_position = position_to_be_placed
	
func get_picked_by(picker):
	target = picker
	freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
