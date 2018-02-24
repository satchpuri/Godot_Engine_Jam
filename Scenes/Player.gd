extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const MAX_SPEED = 300
const ACCELERATION = 50
var motion = Vector2()
var dir = Vector2()
const UP = Vector2(0,0)

const RED = Color(1.0, 0, 0, 0.4)
const GREEN = Color(0, 1.0, 0, 0.4)

var draw_color = GREEN

const DETECT_RADIUS = 200
const FOV = 80
var angle = 90
var isAttacking = false
signal move

var stepCounter = 20

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#func _input(event):
	#if event.is_action_pressed("ui_accept"): get_tree().root.get_node("World/Coin_sound").play()

func _physics_process(delta):
	var stepping = false
	if Input.is_action_pressed("ui_up"):
		motion.y = max(motion.y - ACCELERATION, -MAX_SPEED)	
		stepping = true
	elif Input.is_action_pressed("ui_down"):
		motion.y = min(motion.y + ACCELERATION, MAX_SPEED)
		stepping = true
	else:
		motion.y = lerp(motion.y,0,0.1)
	
	if Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)		
		stepping = true
	elif Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)	
		stepping = true
	else:
		motion.x = lerp(motion.x,0,0.1)
	dir = (get_global_mouse_position() - position).normalized()
	angle = dir.angle()#90 - rad2deg(dir.angle())
	look_at(get_global_mouse_position())
	move_and_slide(motion)
	emit_signal("move")	
	
	if Input.is_action_pressed("attack"):
		$Sprite.play("Attack")
		isAttacking = true
		
	
	if stepping:
		stepCounter -= 1
		$Sprite.play("Move")
	else:
		$Sprite.play("Idle")
		
	if stepCounter <= 0:
		stepCounter = 20
		get_tree().root.get_node("World/Step").play()
	
	pass


func _draw():
	#draw_circle_arc_poly(Vector2(), DETECT_RADIUS,  angle - FOV/2, angle + FOV/2, draw_color)
	pass
	
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)
    var colors = PoolColorArray([color])

    for i in range(nb_points+1):
        var angle_point = angle_from + i*(angle_to-angle_from)/nb_points
        points_arc.push_back(center + Vector2( cos( deg2rad(angle_point) ), sin( deg2rad(angle_point) ) ) * radius)
    draw_polygon(points_arc, colors)
	