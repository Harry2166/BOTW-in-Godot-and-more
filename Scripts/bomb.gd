extends RigidBody3D
class_name Pickable
@onready var player = $"./../Player"
@onready var level = $"."
@onready var player_pick_hand = $"./../Player/SpringArm3D/Camera3D/PickHand"
@onready var mesh = $MeshInstance3D
var boom = preload("res://Objects/dva_bomb.tscn")

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

	if (player.bomb_objs == 0 and Input.is_action_just_pressed("zl-shoulder") and player.bomb_guy):
		var boom_instance = boom.instantiate()
		add_child(boom_instance)
		mesh.visible = false
		$Timer.start()
		player.bomb_objs = 1
		player.bomb_spawned = false
		player_pick_hand.pickable_object = null
		player_pick_hand.picking = false
		
		
	elif (player.bomb_objs == 0 and Input.is_action_just_pressed("cancel") and player.bomb_guy):
		print("im out")
		queue_free()
		player.bomb_objs = 1
		player.bomb_spawned = false
		player_pick_hand.pickable_object = null
		player_pick_hand.picking = false
		

func get_thrown(impulse):
	target = null
	freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	apply_central_impulse(impulse)
	
func get_picked_by(picker):
	target = picker
	freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC


func _on_timer_timeout():
	queue_free()
