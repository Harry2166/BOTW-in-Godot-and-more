extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#@onready var pivot = $CameraMount/Camera3D
#@export var sens = 0.15

func get_coin():
	print("got coin")
	
#func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#func _input(event):
	#if event is InputEventMouseMotion:
		#pivot.rotate_y(deg_to_rad(-event.relative.x * sens))
		#pivot.rotation.x -= deg_to_rad(event.relative.y * sens)
		#pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	move_and_slide()
