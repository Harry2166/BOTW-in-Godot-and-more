extends Metal

func _ready():
	polarity = true
	magnetizedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(1, 0.173, 0.125,1)
	potentialMaterial.albedo_color = Color(1, 0.0784314, 0.576471, 1)
