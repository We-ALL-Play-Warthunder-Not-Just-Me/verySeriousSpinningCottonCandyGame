extends Node2D

@onready var new_player = preload("res://Player/Player.tscn")
@onready var spinners = get_node("../Spinners")
@onready var timer = $Timer
var player
var timer_max = 5

func kill_player():
	player.queue_free()
	timer.start(timer_max)

func spawn_player():
	player = new_player.instantiate()
	spinners.add_child.call_deferred(player)
	player.global_position = self.global_position
