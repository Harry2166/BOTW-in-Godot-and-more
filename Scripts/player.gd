extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_coin():
	print("got coin")

@export var sprint_speed = 15
@export var default_speed = 10
@export var max_speed = 10
@export var acceleration = 70
@export var friction = 60
@export var air_friction = 10
@export var gravity = -40
@export var jump_impulse = 20
@export var mouse_sensitivity = .1
@export var controller_sensitivity = 3
@export var rot_speed = 5
@export var player_polarity = true
var currAbilityIdx = 0
#@export var joystickRightPath
#@onready var joystickRight : VirtualJoystick = get_node(joystickRightPath)

# var velocity = Vector3.ZERO
var snap_vector = Vector3.ZERO
#var num_of_jumps = 2

@onready var spring_arm = $SpringArm3D
@onready var pivot = $Pivot
@onready var camera = $SpringArm3D/Camera3D
@onready var ability_text = $Ability
@onready var health_text = $Health
@onready var aim_ray = $SpringArm3D/Camera3D/RayCast3D
@onready var magnet_collision = $MagneticArea/MagneticCollisionShape
@onready var magnet_collision_shape1 = $MagneticArea/MeshInstance3D
@onready var polarity_text = $Polarity
@onready var crosshair = $Crosshair
@onready var extra_crosshair = $CrosshairExtra
@onready var wood_location = $SpringArm3D/Camera3D/WhereWoodGoes
@onready var bomb_location = $WhereBombSpawns
@onready var bomb_location_in_front = $WhereBombSpawnForReal
@onready var weapon = $WeaponPivot/MeshInstance3D
@onready var anim_player = $AnimationPlayer
@onready var weapon_hitbox = $WeaponPivot/MeshInstance3D/Area3D/CollisionShape3D
@onready var weapon_hitbox_ray = $WeaponPivot/MeshInstance3D/Area3D/Weapon_Collision
@onready var level = $".."
@onready var pick_hand = $SpringArm3D/Camera3D/PickHand
var bomb = preload("res://Objects/bomb.tscn")
var cryonis_block = preload("res://Objects/ice.tscn")

var collision_point = Vector3()
var is_magnet = false
var use_wood = false
var stop_obj = false
var bomb_guy = false
var bomb_spawned = false
var super_jump = false
var ice_ice_tubig = false
var stopped_objs = 1
var bomb_objs = 1
var hit_amount = 0
var bomb_instance
var cryonis_block_instance
var grabbed_objs_amount = 0
var cryo_blocks = 0

func _ready():
	health_text.text = "Health: " + str(PlayerData.curr_health)
	magnet_collision.disabled = true
	crosshair.position.x = get_viewport().size.x / 2 - 32
	crosshair.position.y = get_viewport().size.y / 2 - 64
	crosshair.visible = false
	extra_crosshair.position.x = get_viewport().size.x / 2 - 32
	extra_crosshair.position.y = get_viewport().size.y / 2 - 64
	extra_crosshair.visible = false
	magnet_collision_shape1.visible = false
	weapon_hitbox.disabled = true

func _process(delta):
	if crosshair.position.x != (get_viewport().size.x / 2 - 32):
		crosshair.position.x = get_viewport().size.x / 2 - 32
		crosshair.position.y = get_viewport().size.y / 2 - 64
		extra_crosshair.position.x = get_viewport().size.x / 2 - 32
		extra_crosshair.position.y = get_viewport().size.y / 2 - 64
		
	if Input.is_action_just_pressed("zr-shoulder") and stop_obj:
		$WeaponPivot.visible = true
		anim_player.play("attack")
		weapon_hitbox.disabled = false

	#if num_of_jumps < 1 and is_on_floor():
		#num_of_jumps = 2
	if Input.is_action_just_pressed("left_shoulder"):
		currAbilityIdx += 1
		match (currAbilityIdx % 6):
			0:
				PlayerData.current_ability = PlayerData.Ability.NONE
				is_magnet = false
				use_wood = false
				magnet_collision.disabled = true
				crosshair.visible = false
				stop_obj = false
				magnet_collision_shape1.visible = false
				bomb_guy = false
				super_jump = false
				ice_ice_tubig = false
				ability_text.text = "Current Ability: None"
			1:
				PlayerData.current_ability = PlayerData.Ability.MAGNET
				is_magnet = true
				use_wood = false
				crosshair.visible = false
				magnet_collision.disabled = false
				stop_obj = false
				magnet_collision_shape1.visible = true
				bomb_guy = false
				super_jump = false
				ice_ice_tubig = false
				ability_text.text = "Current Ability: Magnet"
			2:
				PlayerData.current_ability = PlayerData.Ability.WOOD
				is_magnet = false
				use_wood = true
				magnet_collision.disabled = true
				crosshair.visible = true
				stop_obj = false
				magnet_collision_shape1.visible = false
				bomb_guy = false
				super_jump = false
				ice_ice_tubig = false
				ability_text.text = "Current Ability: Wood"
			3:
				PlayerData.current_ability = PlayerData.Ability.STASIS
				is_magnet = false
				use_wood = false
				magnet_collision.disabled = true
				crosshair.visible = true
				stop_obj = true
				stopped_objs = 1
				magnet_collision_shape1.visible = false
				bomb_guy = false
				super_jump = false
				ice_ice_tubig = false				
				ability_text.text = "Current Ability: Stasis"
			4:
				PlayerData.current_ability = PlayerData.Ability.BOMB
				is_magnet = false
				use_wood = false
				magnet_collision.disabled = true
				crosshair.visible = false
				extra_crosshair.visible = false
				stop_obj = false
				magnet_collision_shape1.visible = false
				bomb_guy = true
				super_jump = false
				ice_ice_tubig = false
				ability_text.text = "Current Ability: Bombs"
			5:
				PlayerData.current_ability = PlayerData.Ability.NONE
				is_magnet = false
				use_wood = false
				magnet_collision.disabled = true
				crosshair.visible = true
				stop_obj = false
				magnet_collision_shape1.visible = false
				bomb_guy = false
				super_jump = false
				ice_ice_tubig = true
				ability_text.text = "Current Ability: Cryonis"
				
	if Input.is_action_just_pressed("A"):
		if is_magnet:
			player_polarity = !player_polarity
			polarity_text.text = "Polarity: " + ("Negative" if not player_polarity else "Positive")
		elif bomb_guy and bomb_objs == 1:
			spawn_bomb()
	
func _physics_process(delta):
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(input_vector, direction, delta)
	apply_friction(direction, delta)
	apply_gravity(delta)
	update_snap_vector()
	jump()
	apply_controller_rotation()
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	move_and_slide()
	#velocity = velocity # move_and_slide_with_snap(linear_velocity = velocity, snap = snap_vector, up_direction = Vector3.UP, stop_on_slope = true, max_slides = 4, floor_max_angle = 0.785398, infinite_inertia = false)
	for idx in get_slide_collision_count(): # get_slide_count()
		var collision = get_slide_collision(idx)
	
	if aim_ray.is_colliding():
		if use_wood and aim_ray.get_collider().is_in_group("wood"):
			extra_crosshair.visible = true
			aim_ray.get_collider().get_used()
			grabbed_objs_amount += 1
		if stop_obj and aim_ray.get_collider().is_in_group("stasised"):
			extra_crosshair.visible = true
			if Input.is_action_pressed("A") and stopped_objs == 1: 
				aim_ray.get_collider().get_stopped()
				stopped_objs -= 1
		if ice_ice_tubig and aim_ray.get_collider() is StaticBody3D:
			extra_crosshair.visible = true
			if Input.is_action_just_pressed("A") and cryo_blocks < 3:
				cryonis_block_instance = cryonis_block.instantiate()
				cryonis_block_instance.set_position(aim_ray.get_collision_point())
				level.add_child(cryonis_block_instance)
				cryo_blocks += 1
		if ice_ice_tubig and aim_ray.get_collider() is RigidBody3D:
			extra_crosshair.visible = true
	else:
		extra_crosshair.visible = false
	
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
func get_direction(input_vector):
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	
func apply_movement(input_vector, direction, delta):
	max_speed = default_speed
	if Input.is_action_pressed("sprint"):
		max_speed = sprint_speed
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-input_vector.x, -input_vector.z), rot_speed * delta)
		
func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(Vector3.ZERO, air_friction * delta).x
			velocity.z = velocity.move_toward(Vector3.ZERO, air_friction * delta).z
		
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jump_impulse)
	
func update_snap_vector():
	snap_vector = -get_floor_normal() if is_on_floor() else Vector3.DOWN
	
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap_vector = Vector3.ZERO
		velocity.y = jump_impulse
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2
		
func apply_controller_rotation():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if InputEventJoypadMotion:
		rotate_y(deg_to_rad(-axis_vector.x) * controller_sensitivity)
		spring_arm.rotate_x(deg_to_rad(-axis_vector.y) * controller_sensitivity)
		
func _on_fov_updated(value):
	camera.fov = value
	
func _on_mouse_sens_updated(value):
	mouse_sensitivity = value

func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("metal") and is_magnet:
		body.go_to_magnet()
	elif body.is_in_group("metal") and not is_magnet:
		body.become_magnetic = false

func _on_magnetic_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("metal") and not is_magnet:
		body.become_magnetic = false

func _on_magnetic_area_body_exited(body):
	if body.is_in_group("metal") and not is_magnet:
		body.become_magnetic = false

func _on_hit_detection_body_entered(body):
	if body.has_method("hurt_player"):
		body.hurt_player()
		PlayerData.curr_health -= 1
		health_text.text = "Health: " + str(PlayerData.curr_health)

func _on_area_3d_body_entered(body):
	if body.is_sleeping:
		collision_point = weapon_hitbox_ray.get_collision_point()
		hit_amount += 1

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		weapon_hitbox.disabled = true
		$WeaponPivot.visible = false
		
func spawn_bomb():
	bomb_instance = bomb.instantiate()
	bomb_instance.set_position(bomb_location_in_front.global_position)
	bomb_spawned = true
	bomb_objs -= 1
	level.add_child(bomb_instance)
