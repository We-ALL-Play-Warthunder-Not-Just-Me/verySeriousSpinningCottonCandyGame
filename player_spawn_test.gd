extends Node2D

@onready var new_player = preload("res://Player/Player.tscn")
@onready var new_opponent = preload("res://Enemies/Enemy.tscn")
@onready var spinners = get_node("../Spinners")
@onready var spinners_children = spinners.get_children()
@onready var timer = $Timer
var timer_max = 5
var spinners_dictionary = {}

func _ready() -> void:
	for child in spinners_children:
		spinners_dictionary.get_or_add(child.name, child.global_position)

func kill_spinner(target: Node2D):
	#Getting the name of who just died and their initial starting point before deletion
	var name = target.name
	var position = spinners_dictionary[name]
	target.queue_free()
	await get_tree().create_timer(timer_max).timeout
	spawn_spinner(name, position)

func spawn_spinner(name: String, position: Vector2):
	var spinner = new_opponent.instantiate()
	if name == "Player":
		spinner = new_player.instantiate()
	spinner.name = name
	spinners.add_child.call_deferred(spinner)
	spinner.global_position = position
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
