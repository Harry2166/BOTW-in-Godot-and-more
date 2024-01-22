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
var num_of_jumps = 2
var currAbilityIdx = 0
#@export var joystickRightPath
#@onready var joystickRight : VirtualJoystick = get_node(joystickRightPath)

# var velocity = Vector3.ZERO
var snap_vector = Vector3.ZERO

@onready var spring_arm = $SpringArm3D
@onready var pivot = $Pivot
@onready var camera = $SpringArm3D/Camera3D
@onready var text = $TextEdit
@onready var crosshair = $Crosshair
@onready var aim_ray = $SpringArm3D/Camera3D/RayCast3D

var is_magnet = false
var use_wood = false

func _ready():
	crosshair.position.x = get_viewport().size.x / 2 - 32
	crosshair.position.y = get_viewport().size.y / 2 - 32
	crosshair.visible = false

func _process(delta):
	if num_of_jumps < 1 and is_on_floor():
		num_of_jumps = 2
	if Input.is_action_just_pressed("left_shoulder"):
		currAbilityIdx += 1
		match (currAbilityIdx % 3):
			0:
				PlayerData.current_ability = PlayerData.Ability.NONE
				is_magnet = false
				use_wood = false
				text.text = "Current Ability: "
			1:
				PlayerData.current_ability = PlayerData.Ability.MAGNET
				is_magnet = true
				use_wood = false
				text.text = "Current Ability: Magnet"
			2:
				PlayerData.current_ability = PlayerData.Ability.WOOD
				is_magnet = false
				use_wood = true
				text.text = "Current Ability: Wood"
				
	if Input.is_action_just_pressed("get_crosshair_out") and use_wood:
		crosshair.visible = !crosshair.visible
		
	if crosshair.visible and not use_wood:
		crosshair.visible = !crosshair.visible
	
	if use_wood and aim_ray.is_colliding():
		print(aim_ray.get_collider().name)
	
func _physics_process(delta):
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(input_vector, direction, delta)
	apply_friction(direction, delta)
	apply_gravity(delta)
	update_snap_vector()
	jump()
	apply_controller_rotation()
	#rotate_player()
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	move_and_slide()
	#velocity = velocity # move_and_slide_with_snap(linear_velocity = velocity, snap = snap_vector, up_direction = Vector3.UP, stop_on_slope = true, max_slides = 4, floor_max_angle = 0.785398, infinite_inertia = false)
	for idx in get_slide_collision_count(): # get_slide_count()
		var collision = get_slide_collision(idx)
		#if collision.collider.is_in_group("bodies"):
			#collision.collider.apply_central_impulse(-collision.normal * velocity.length() * push)
	
#func rotate_player():
	#rotate_y(deg_to_rad(joystickRight.get_output().x * mouse_sensitivity))
	#spring_arm.rotate_x(deg_to_rad(joystickRight.get_output().y * mouse_sensitivity))	
	
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
#		pivot.look_at(global_transform.origin + direction, Vector3.UP)
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
		num_of_jumps -= 1
	if Input.is_action_just_pressed("jump") and num_of_jumps > 0 and not is_on_floor():
		num_of_jumps -= 1
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
	if body.has_method("go_to_magnet") and is_magnet:
		body.go_to_magnet()
	elif body.has_method("go_to_magnet") and not is_magnet:
		body.become_magnetic = false


func _on_magnetic_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("go_to_magnet") and not is_magnet:
		body.become_magnetic = false


func _on_magnetic_area_body_exited(body):
	if body.has_method("go_to_magnet") and not is_magnet:
		body.become_magnetic = false
