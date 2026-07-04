extends Node2D

@export var opponent_one: BaseSpinner
@export var opponent_two: BaseSpinner
@export var opponent_three: BaseSpinner

@export var player: BaseSpinner
@export var center_stage: Node2D
@onready var follow_this = player
@onready var follow_one = opponent_one
@onready var follow_two = opponent_two
@onready var follow_three = opponent_three
const LIMIT_DISTANCE = 120

@onready var spinners: Node = get_node("/root/MainGame/Spinners")
@onready var marker_one = $JimbyTracker
@onready var marker_two = $BlueTornadoTracker
@onready var marker_three = $NibTracker

var opponent_one_name
var opponent_two_name
var opponent_three_name

var player_lives = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opponent_one_name = opponent_one.name
	opponent_two_name = opponent_two.name
	opponent_three_name = opponent_three.name
	
	spinners.child_entered_tree.connect(spinner_respawned)
	spinners.child_exiting_tree.connect(spinner_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = follow_this.position
	if player_lives:
			tracker_follow(follow_one, marker_one)
			tracker_follow(follow_two, marker_two)
			tracker_follow(follow_three, marker_three)

func tracker_follow(follow: Node, marker: Sprite2D):
	if follow is BaseSpinner:
		var marker_limit = follow.position - player.position
		marker.position = marker_limit.limit_length(LIMIT_DISTANCE)
		marker.rotation = marker.position.angle()
		if follow.stats.CurrentHP > (follow.stats.MaxHP/2):
			marker.frame = 2
		elif follow.stats.CurrentHP > (follow.stats.MaxHP/4):
			marker.frame = 1
		elif follow.stats.CurrentHP > 0:
			marker.frame = 0
		if follow.screen_checker.is_on_screen():
			marker.visible = false
		else:
			marker.visible = true
func test():
	print("Sup")

func spinner_died(spinner: BaseSpinner):
	if spinner.name == "Player":
		visible = false
		player_lives = false
		follow_this = center_stage
	if spinner.name == opponent_one_name:
		follow_one = center_stage
		marker_one.visible = false
	if spinner.name == opponent_two_name:
		follow_two = center_stage
		marker_two.visible = false
	if spinner.name == opponent_three_name:
		follow_three = center_stage
		marker_three.visible = false
	
func spinner_respawned(spinner: BaseSpinner):
	if spinner.name == "Player":
		visible = true
		player_lives = true
		player = spinner
		follow_this = player
	if spinner.name == opponent_one_name:
		opponent_one = spinner
		follow_one = opponent_one
	if spinner.name == opponent_two_name:
		opponent_two = spinner
		follow_two = opponent_two
	if spinner.name == opponent_three_name:
		opponent_three = spinner
		follow_three = opponent_three
