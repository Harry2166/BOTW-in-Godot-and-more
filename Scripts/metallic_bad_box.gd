extends Metal

func _ready():
	polarity = true
	magnetizedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(0, 1, 0, 1)
	potentialMaterial.albedo_color = Color(1, 0.0784314, 0.576471, 1)
	stopMaterial.albedo_color = Color(0.721569, 0.52549, 0.0431373, 1)
	add_to_group("stasised")

func hurt_player():
	print("ouch")
