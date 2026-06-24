extends Node2D

@onready var new_player = preload("res://Player/Player.tscn")
@onready var new_opponent = preload("res://Enemies/Enemy.tscn")
@onready var spinners = get_node("../Spinners")
@onready var timer = $Timer
@export var player: Node2D
var timer_max = 5

func kill_player():
	player.queue_free()
	timer.start(timer_max)

func spawn_player():
	player = new_player.instantiate()
	spinners.add_child.call_deferred(player)
	player.global_position = self.global_position
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
