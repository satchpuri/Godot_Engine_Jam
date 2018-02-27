extends KinematicBody2D

const RED = Color(1.0, 0, 0, 0.4)
const GREEN = Color(0, 1.0, 0, 0.4)
const DETECT_RADIUS = 400
const FOV = 70

enum EnemyState {
	Patrol,
	Alert,
	Attack,
	Death
}

var state = EnemyState.Patrol
var draw_color = GREEN

var soundFlag = false
var angle = -90
var currrentDirection = Vector2()
var pathUpdateTimer = 0
var currentPatrol = "A"
var currentPatrolIndex = 0
var patrol = null
var health = 100
var isAttacking = false

export var patrolPoints = ["PatrolA", "PatrolB"]
var patrols = {};
onready var nav = get_parent().get_node("Navigation2D")
onready var player = get_parent().get_node("Player")
onready var health_bar = $ProgressBar
onready var ray_cast = $RayCast2D
var path = []

func _ready():
	loadPatrols()
	currentPatrol = patrolPoints[0]
	ray_cast.enabled = true
	pass

func loadPatrols():
	var i=0
	while(i<patrolPoints.size()):
		patrols[patrolPoints[i]] = get_parent().get_node(patrolPoints[i])
		i = i+1

func _process(delta):
	update_state()
	update()	
	update_animation()
	if state == EnemyState.Patrol:
		go_to_target(patrol,delta)	# go to next patrol position
	elif state == EnemyState.Alert || state == EnemyState.Attack:
		pathUpdateTimer += delta
		go_to_target(player,delta)
		if(pathUpdateTimer>1):
			pathUpdateTimer = 0
			recalculate_path(player) #Update path to player once every second
		if state == EnemyState.Attack:
			attack_player()
		else:
			isAttacking = false
	pass

func attack_player():	
	var frameCount = $Sprite.frames.get_frame_count("attack")
	if $Sprite.frame == frameCount/2 and $Sprite.animation == "attack" && !isAttacking:
		isAttacking = true
		player.inflict_damage(50)
	pass

func update_state():	
	health_bar.value = health	
	if state == EnemyState.Death:
		$CollisionShape2D.disabled = true
		$Sprite.stop()
		return
		pass
	var playerDirection = (player.position - position).normalized()
	var angleBetween = rad2deg(currrentDirection.angle_to(playerDirection));
	ray_cast.cast_to = player.position
	if position.distance_to(player.position)<DETECT_RADIUS && abs(angleBetween) < FOV/2:
		draw_color = RED
		state = EnemyState.Alert
		if position.distance_to(player.position)< 80:
			state = EnemyState.Attack
		if !soundFlag:
			get_tree().root.get_node("World/Alert").play()
			soundFlag = true
	else:
		#soundFlag = false
		patrol = get_current_patrol()
		if position.distance_to(patrol.position)<2:
			reassign_patrol_point()
		draw_color = GREEN
		#state = EnemyState.Patrol
	pass

func ray_cast_check():
	return ray_cast.is_colliding() && ray_cast.get_collider().is_in_group("Player")

func update_animation():
	if state == EnemyState.Patrol || state == EnemyState.Alert:
		$Sprite.play("move")
	elif state == EnemyState.Attack:
		$Sprite.play("attack")

func get_current_patrol():
	return patrols[patrolPoints[currentPatrolIndex]]

func reassign_patrol_point():
	currentPatrolIndex = (currentPatrolIndex + 1) % patrolPoints.size()

func recalculate_path(target):
	path = nav.get_simple_path(position,target.position)

#Calculates path to target and moves towards target
func go_to_target(target, delta):
	if path.size()==0 and position.distance_to(target.position)>2 :
		path = nav.get_simple_path(position,target.position)
	elif path.size()>0:	
		var d = position.distance_to(path[0])	
		if d>2:			
			var dir = (path[0] - position).normalized()
			currrentDirection = dir	
			position = position.linear_interpolate(path[0], 150*delta/d)					
			rotation_degrees = lerp(rotation_degrees, 90 + rad2deg(dir.angle()), 0.1)
		else:
			path.remove(0)
	pass

func inflict_damage(amount):
	health -= amount
	if health<=0:
		state = EnemyState.Death
		print("Dead")
		update()

func _draw():
	if state != EnemyState.Death:
		draw_circle_arc_poly(Vector2(), DETECT_RADIUS,  angle - FOV/2, angle + FOV/2, draw_color)
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