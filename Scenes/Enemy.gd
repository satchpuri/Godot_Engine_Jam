extends KinematicBody2D

const RED = Color(1.0, 0, 0, 0.4)
const GREEN = Color(0, 1.0, 0, 0.4)
enum EnemyState {
	Patrol,
	Alert,
	Attack
}

var state = EnemyState.Patrol
var draw_color = GREEN
const DETECT_RADIUS = 400
const FOV = 70
var angle = -90
var currrentDirection = Vector2()

onready var nav = get_parent().get_node("Navigation2D")
onready var target = get_parent().get_node("Target")
onready var player = get_parent().get_node("Player")
var path = []

func _ready():
	pass

func _process(delta):
	update_state()
	if(state == EnemyState.Patrol):
		go_to_target(target,delta)	# go to next patrol position
	elif state==EnemyState.Alert:
		go_to_target(player,delta)
	pass

func update_state():	
	var playerDirection = (player.position - position).normalized()
	var angleBetween = rad2deg(currrentDirection.angle_to(playerDirection));

	if position.distance_to(player.position)<DETECT_RADIUS && abs(angleBetween) < FOV/2:
		draw_color = RED
		state = EnemyState.Alert
		update()
	else:
		draw_color = GREEN
		state = EnemyState.Patrol
		update()
	pass

func recalculate_path(target):
	path = nav.get_simple_path(position,target.position)

#Calculates path to target and moves towards target
func go_to_target(target, delta):
	if(path.size()==0):
		path = nav.get_simple_path(position,target.position)
	else:		
		var d = position.distance_to(path[0])
		if d>2:
			position = position.linear_interpolate(path[0], 150*delta/d)
			var dir = (path[0] - position).normalized()
			currrentDirection = dir
			rotation_degrees = lerp(rotation_degrees, 90 + rad2deg(dir.angle()), 0.1)
		else:
			path.remove(0)
	pass

func _draw():
	print(draw_color)
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