extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var remaining = 2

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func unlock():
	get_tree().root.get_node("World/Door/Locked Sprite").hide()
	get_tree().root.get_node("World/Door/Unlocked Sprite").show()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
