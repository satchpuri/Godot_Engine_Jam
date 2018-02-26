extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var remaining = 0
var isOver = false
onready var player = get_parent().get_node("Player")
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (position.distance_to(player.position)< 120) and !isOver:
		print("Game Over")
		isOver = true
		#get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass
	
func unlock():
	
	get_tree().root.get_node("World/Door/Locked Sprite").hide()
	get_tree().root.get_node("World/Door/Unlocked Sprite").show()
	$StaticBody2D.get_node("CollisionShape2D").disabled = true
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
