extends Node


onready var screen_size = Vector2(OS.get_screen_size().x, OS.get_screen_size().y)
onready var player = get_node("Player")
onready var exit = get_node("exit")
onready var last_player_pos = player.position

func _ready():
	pass

func _process(delta):
	if player.isDead or exit.isOver:
		$CanvasLayer/Message.text = "Game Over!"
		$CanvasLayer/Message.align = Label.ALIGN_CENTER

func _on_Player_move():
	var player_offset = last_player_pos - player.position
	last_player_pos = player.position
	var canvas_transform = get_viewport().get_canvas_transform()
	canvas_transform[2] += player_offset
	get_viewport().set_canvas_transform(canvas_transform)
	pass 
