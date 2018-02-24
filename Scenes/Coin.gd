extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var collected = false
var door

func _ready():
	door = get_tree().root.get_node("World/Door")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var player = get_tree().root.get_node("World/Player")
	if transform.get_origin().distance_to(player.transform.get_origin()) < 60 && !collected:
		collected = true
		get_tree().root.get_node("World/Coin_sound").play()
		door.remaining -= 1
		if door.remaining == 0:
			door.unlock()
		hide()
#	pass
