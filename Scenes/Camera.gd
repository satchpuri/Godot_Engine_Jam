extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if event.is_action_pressed("ui_left"): translation.x -= 0.1;
	if event.is_action_pressed("ui_right"): translation.x += 0.1;
	if event.is_action_pressed("ui_up"): translation.z -= 0.1;
	if event.is_action_pressed("ui_down"): translation.z += 0.1;