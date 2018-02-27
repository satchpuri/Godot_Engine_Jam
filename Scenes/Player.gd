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
var stepping = false
var isDead = false
var health = 100
var attackTime = 0
signal move

var stepCounter = 20
onready var ray_cast = $RayCast2D
onready var health_bar = $ProgressBar

var latest_collider = null

func _ready():
	pass

func _physics_process(delta):	
	health_bar.value = health
	attackTime += delta
	if isDead:
		return
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
	ray_cast.cast_to = position + dir * 0.1 

	if Input.is_action_pressed("attack") and !isAttacking:
		var enemy = get_closest_enemy()
		if enemy!=null:
			enemy.inflict_damage(100)
		attackTime = 0
		isAttacking = true
#		if(ray_cast.is_colliding()):
#			var collider = ray_cast.get_collider()
#			if collider.is_in_group("Enemy") and global_position.distance_to(collider.position) < 100:
#				print("Hit Enemy")
#				collider.inflict_damage(100)
	
	if attackTime > 1:
		isAttacking = false
	
	if stepping:
		stepCounter -= 1
	
	if stepCounter <= 0:
		stepCounter = 20
		get_tree().root.get_node("World/Step").play()
	else:
		stepping = false
	update_animation()
	pass

func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var min_enemy = null
	var min_distance = 999999
	for enemy in enemies:
		var d = position.distance_to(enemy.position)
		if d < min_distance:
			min_enemy = enemy
			min_distance = d
	if min_distance<90:
		return min_enemy
	else:
		return null

func update_animation():	
	if isAttacking:
		#print($Sprite.playing)
		$Sprite.play("Attack")
	elif stepping:
		$Sprite.play("Move")
	else:
		$Sprite.play("Idle")
		
func inflict_damage(amount):
	health -= amount
	if health<=0:
		health = 0
		isDead = true
		#get_tree().paused = true
		get_parent().get_node("BGM").stop()

func _draw():
	draw_line($Sprite.position, position + dir, GREEN)
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
	

func _on_Sprite_animation_finished():
	isAttacking = false
	pass # replace with function body
