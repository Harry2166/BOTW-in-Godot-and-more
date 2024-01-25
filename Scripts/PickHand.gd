extends Area3D
class_name PickHand

var pickable_object = null
var picking = false
@onready var bomb_location = $"../WhereBombSpawns"
# Called when the node enters the scene tree for the first time.
func _ready():
	await("ready")
	
func _unhandled_input(event):
	if event.is_action_pressed("A") and pickable_object:
		picking = true
		pickable_object.get_picked_by(bomb_location)

func _on_body_entered(body):
	if picking:
		return
	
	if body.is_in_group("pickable"):
		pickable_object = body


func _on_body_exited(body):
	if body.is_in_group("pickable") and not picking:
		pickable_object = null
