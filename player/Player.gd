extends KinematicBody2D


export (int) var walk_speed = 400
export (NodePath) var spawn_path
const GRAVITY = -9.81
export var fall_multiplier = 2 
export var low_jump_multiplier = 30
export var jump_velocity = 450 #Jump height

onready var spawn_point = get_node(spawn_path)
onready var screen_size = get_viewport_rect().size

#Physics
var velocity = Vector2()
export var gravity = 8


func disable():
	set_process(false)
	set_physics_process(false)


func _ready():
	position = spawn_point.position


func _physics_process(_delta):
	#Applying gravity to player
	velocity.y += gravity 
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -walk_speed
		$Sprite.flip_h = true
		$Sprite.play("move")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = walk_speed
		$Sprite.flip_h = false
		$Sprite.play("move")
	else:
		velocity.x = 0
		$Sprite.set_animation("stand")
		$Sprite.stop()

	#Jump Physics
	if velocity.y > 0: #Player is falling
		velocity += Vector2.UP * GRAVITY * fall_multiplier #Falling action is faster than jumping action | Like in mario

	elif velocity.y < 0 && Input.is_action_just_released("ui_up"): #Player is jumping 
		velocity += Vector2.UP * GRAVITY * low_jump_multiplier #Jump Height depends on how long you will hold key

	if velocity.y < 0:
		$Sprite.play("jump")

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"): 
			velocity = Vector2.UP * jump_velocity #Normal Jump action

	velocity = move_and_slide(velocity, Vector2.UP)
