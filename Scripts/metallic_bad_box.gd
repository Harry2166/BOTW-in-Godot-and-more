extends Metal

func _ready():
	polarity = true
	magnetizedMaterial.albedo_color = Color(0.92,0.69,0.13,1.0)
	normalMaterial.albedo_color = Color(0, 1, 0, 1)
	potentialMaterial.albedo_color = Color(1, 0.0784314, 0.576471, 1)

func _physics_process(delta):
	if become_magnetic and player.is_magnet:
		if polarity != player.player_polarity:
			position = position.lerp(player.position, 0.025)
		else:
			var going_away = Vector3(player.velocity.x, position.y, player.velocity.z)
			position = position.lerp(going_away, 0.025)
		mesh.material_override = magnetizedMaterial
	elif player.is_magnet:
		mesh.material_override = potentialMaterial
	else:
		mesh.material_override = normalMaterial

func go_to_magnet():
	become_magnetic = true

func hurt_player():
	print("ouch")