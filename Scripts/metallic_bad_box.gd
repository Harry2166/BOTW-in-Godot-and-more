extends Metal

func _ready():
	polarity = true
	magnetizedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(0, 1, 0, 1)
	potentialMaterial.albedo_color = Color(1, 0.0784314, 0.576471, 1)
	stopMaterial.albedo_color = Color(0.721569, 0.52549, 0.0431373, 1)

func go_to_magnet():
	become_magnetic = true

func hurt_player():
	print("ouch")
	
func get_stopped():
	sleeping = true
	is_sleeping = true
	$Timer.start()
	
func _on_timer_timeout():
	is_sleeping = false
	sleeping = false
	print("IM OUT")
