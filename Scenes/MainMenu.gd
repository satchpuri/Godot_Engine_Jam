extends HBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	var size = get_viewport().get_visible_rect().size
	set_size(size)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass