extends Node3D
class_name Stasis

@onready var itself = $".."
@onready var player = $"../../../Player"

var is_sleeping = false
var accumulation = Vector3.ZERO

func get_stopped():
	itself.is_sleeping = true
	is_sleeping = true
	itself.freeze = true
	$"../Timer".start()
	
func _on_timer_timeout():
	is_sleeping = false
	itself.freeze = false
	player.stopped_objs = 1
	print(player)
	hit(player.collision_point, player.hit_amount)
	player.hit_amount = 0
	
func hit(collision_point, hit_amount):
	var direction = (itself.global_transform.origin - collision_point).normalized()
	var magnitude = accumulation.length() + hit_amount
	print("accumulation" + str(accumulation))
	print("hit_amount" + str(hit_amount))
	print("itself.global_transform.origin" + str(itself.global_transform.origin))
	print("collision_point" + str(collision_point))
	accumulation = direction * magnitude
	itself.apply_central_impulse(accumulation)
	accumulation = Vector3.ZERO
