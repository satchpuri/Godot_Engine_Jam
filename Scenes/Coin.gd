extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var collected = false
var door
var total = 12

func _ready():
	door = get_parent().get_node("exit")
	door.remaining += 1
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	get_parent().get_node("CanvasLayer/Loots").text = "Loot Collected: " + str(total - door.remaining) + "/" + str(total)
	var player = get_tree().root.get_node("World/Player")
	if transform.get_origin().distance_to(player.transform.get_origin()) < 60 && !collected:
		collected = true
		get_tree().root.get_node("World/Coin_sound").play()
		door.remaining -= 1
		if door.remaining == (total - 3):
			door.unlock()
		hide()
#	pass
