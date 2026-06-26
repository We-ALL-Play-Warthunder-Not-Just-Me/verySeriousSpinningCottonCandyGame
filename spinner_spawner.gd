extends Node

@onready var new_player = preload("res://Player/Player.tscn")
@onready var new_opponent = preload("res://Enemies/Enemy.tscn")
@onready var spinners_children = self.get_children()
var timer_max = 5
var spinners_dictionary = {}

func _ready() -> void:
	print(self.get_children())
	print(spinners_dictionary)
	for child in spinners_children:
		spinners_dictionary.get_or_add(child.name, child.global_position)
	print(spinners_dictionary)

func kill_spinner(target: Node2D):
	#Getting the name of who just died and their initial starting point before deletion. Also their Sprite
	var name_of_dead = target.name
	var stored_position = spinners_dictionary[name_of_dead]
	var sprite_of_dead = target.get_child(1).frame
	target.queue_free()
	await get_tree().create_timer(timer_max).timeout
	spawn_spinner(name_of_dead, stored_position, sprite_of_dead)

func spawn_spinner(spinner_name: String, start_position: Vector2, spinner_sprite: int):
	var spinner = new_opponent.instantiate()
	if spinner_name == "Player":
		spinner = new_player.instantiate()
	spinner.name = spinner_name
	spinner.get_child(1).frame = spinner_sprite
	self.add_child.call_deferred(spinner)
	spinner.global_position = start_position
	
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
