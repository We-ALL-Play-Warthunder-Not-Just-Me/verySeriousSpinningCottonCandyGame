extends Node2D

@export var gravity: float
@export var candy_timer: Timer
@export var candy_timer_label: Label
@export var game_timer: Timer
@export var game_timer_label: Label
@export var middle_text: RichTextLabel
@export var camera: Camera2D
@onready var start_timer = $CountdownToPlay
var round_playing = false
var hold_gravity
var total_time
var tick
var number

func _ready() -> void:
	tick = 0
	hold_gravity = gravity
	gravity = 0.0
	total_time = start_timer.wait_time
	middle_text.visible = true
	middle_text.clear()
	number = "[color=e03c28][outline_color=4f1507][font_size={96}][outline_size={32}][b]3"
	middle_text.append_text(number + "[/b][/outline_size][/font_size][/outline_color][/color]")

func start_round():
	middle_text.visible = false
	camera.start_camera()
	middle_text.clear()
	gravity = hold_gravity
	game_timer.start()
	game_timer_label.visible = true
	candy_timer.start()
	candy_timer_label.visible = true
	round_playing = true

func timer_ticks():
	tick += 1
	if tick == 1:
		middle_text.clear()
		number = "[color=ffe737][outline_color=ad4e1a][font_size={128}][outline_size={33}][b]2"
		middle_text.append_text(number + "[/b][/outline_size][/font_size][/outline_color][/color]")
	elif tick == 2:
		middle_text.clear()
		number = "[color=8cd612][outline_color=00604b][font_size={160}][outline_size={34}][b]1"
		middle_text.append_text(number + "[/b][/outline_size][/font_size][/outline_color][/color]")
	elif tick == 3:
		middle_text.clear()
		number = "[shake rate=200.0 level=30 connected=1][color=fec9ed][outline_color=cf3c71][font_size={192}][outline_size={36}][b]GO!"
		middle_text.append_text(number + "[/b][/outline_size][/font_size][/outline_color][/color][/shake]")
	else:
		start_timer.stop()
		start_round()

func _process(delta: float) -> void:	
	if round_playing == false and gravity > 0.0:
		gravity += delta
