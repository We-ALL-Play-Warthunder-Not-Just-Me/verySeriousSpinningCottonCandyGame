extends Label

@onready var countdown = $Timer
@onready var the_dark = get_node("/root/MainGame/TheDark")
@onready var round_over_text = get_node("/root/MainGame/CanvasLayer/EndText")
@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var candy_tracker = get_node("/root/MainGame/CanvasLayer/CottonCandyTracker")
@onready var camera = get_node("/root/MainGame/FancyCamera")
@export var candy_bank: PlayerCottonCandyTotal = load("res://Player/CottonCandyBank.tres")
var final_text
var round_over = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(countdown.time_left)
	self.text = str(ceili(countdown.time_left))
	if round_over == true:
		if Input.is_action_just_pressed("ui_accept"):
			var level_fqn = "res://UI/UpgradeScreen.tscn"
			get_tree().change_scene_to_file(level_fqn)

func calculate_scores():
	final_text = "[b]FIN[/b]"
	var scores_array = []
	for player in candy_tracker.spinners_dictionary:
		scores_array.append([candy_tracker.spinners_dictionary[player], player])
	scores_array.sort()
	scores_array.reverse()
	var player_placement = 0
	var win_multiplier = 0
	for scores in scores_array:
		player_placement+= 1
		var score_candy = "\n" + scores[1] + " Candy: " + str(scores[0])
		final_text += score_candy
		if scores[1] == "Player":
			if player_placement == 1: win_multiplier = 2.0
			elif player_placement == 2: win_multiplier = 1.5
			elif player_placement == 3: win_multiplier = 1.0
			elif player_placement == 4: win_multiplier = 0.5
	final_text += "\nPlayer gets a multiplier of: " + str(win_multiplier)
	round_over_text.append_text(final_text)
	round_over_text.visible = true
	var player_winnings = floori(candy_tracker.spinners_dictionary["Player"] * win_multiplier)
	print("Player won this much: ", player_winnings)
	candy_bank.addCottonCandy(player_winnings)

func round_end():
	Engine.set_time_scale(1.0)
	camera.switch_camera_points(center_stage)
	the_dark.visible = false
	round_over = true
	center_stage.round_playing = false
	candy_tracker.get_child(0).set_one_shot(true)
	await get_tree().create_timer(1.0).timeout
	calculate_scores()
