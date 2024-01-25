extends Area3D
class_name PickHand

var pickable_object = null
var picking = false
var strength = 0.0
var strength_speed = 5.0
var max_strength = 10.0

@onready var bomb_location = $"../WhereBombSpawns"
# Called when the node enters the scene tree for the first time.
func _ready():
	await("ready")
	
func _unhandled_input(event):
	if event.is_action_pressed("A") and pickable_object:
		picking = true
		pickable_object.get_picked_by(bomb_location)
	if Input.is_action_pressed("zr-shoulder") and pickable_object:
		release_object()
		#strength = min(max_strength, strength + delta * strength_speed)

func _process(delta):
	if pickable_object:
		if Input.is_action_pressed("zr-shoulder"):
			strength = max(max_strength, strength + delta * strength_speed)

func release_object():
	var dir = (global_transform.basis.z.normalized() * strength + Vector3(2.5,2.5,2.5)) * 4
	pickable_object.get_thrown(dir)
	pickable_object = null
	picking = false
	strength = 0.0
	
func _on_body_entered(body):
	if picking:
		return
	
	if body.is_in_group("pickable"):
		pickable_object = body

func _on_body_exited(body):
	if body.is_in_group("pickable") and not picking:
		pickable_object = null
