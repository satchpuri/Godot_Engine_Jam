extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const MAX_SPEED = 200
const ACCELERATION = 50

var motion = Vector2()
var dir = Vector2()
const UP = Vector2(0,0)

signal move

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		motion.y = max(motion.y - ACCELERATION, -MAX_SPEED)	
	elif Input.is_action_pressed("ui_down"):
		motion.y = min(motion.y + ACCELERATION, MAX_SPEED)
	else:
		motion.y = lerp(motion.y,0,0.2)
	
	if Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)		
	elif Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)	
	else:
		motion.x = lerp(motion.x,0,0.2)
	dir = (get_local_mouse_position() - position).normalized()
	look_at(get_global_mouse_position())
	move_and_slide(motion)
	emit_signal("move")
	pass
	
	
	