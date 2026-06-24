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
	final_text = "[outline_size={32}][b][color=ffe737][outline_color=4f1507]FIN[/outline_color][/color][/b][/outline_size]"
	var scores_array = []
	for player in candy_tracker.spinners_dictionary:
		scores_array.append([candy_tracker.spinners_dictionary[player], player])
	scores_array.sort()
	scores_array.reverse()
	var placement = 0
	var win_multiplier = 0
	var multiplier_display = ""
	for scores in scores_array:
		placement += 1
		var spinner_placed: String
		if placement == 1:
			spinner_placed = "[color=fec9ed][outline_color=cf3c71]1st - "
		elif placement == 2:
			spinner_placed = "[color=cc69e4][outline_color=00177d]2nd - "
		elif placement == 3:
			spinner_placed = "[color=6264dc][outline_color=211640]3rd - "
		elif placement == 4:
			spinner_placed = "[color=e03c28][outline_color=4f1507]4th - "
			
		var score_candy = "\n" + spinner_placed + scores[1] + ": " + str(scores[0]) + "[/outline_color][/color]"
		final_text += score_candy
		if scores[1] == "Player":
			if placement == 1:
				win_multiplier = 2.0 
				multiplier_display = "[color=fec9ed][outline_color=cf3c71][font_size={56}]\n\nPlayer gets a multiplier of: " + str(win_multiplier)
			elif placement == 2:
				win_multiplier = 1.5
				multiplier_display = "[color=cc69e4][outline_color=00177d][font_size={56}]\n\nPlayer gets a multiplier of: " + str(win_multiplier)
			elif placement == 3:
				win_multiplier = 1.0
				multiplier_display = "[color=6264dc][outline_color=211640][font_size={56}]\n\nPlayer gets a multiplier of: " + str(win_multiplier) 
			elif placement == 4:
				win_multiplier = 0.5
				multiplier_display = "[color=e03c28][outline_color=4f1507][font_size={56}]\n\nYour Candy Multiplier: " + str(win_multiplier)
	final_text += multiplier_display
	round_over_text.append_text(final_text)
	round_over_text.visible = true
	var player_winnings = floori(candy_tracker.spinners_dictionary["Player"] * win_multiplier)
	print("Player won this much: ", player_winnings)
	candy_bank.addCottonCandy(player_winnings)

func round_end():
	Engine.set_time_scale(1.0)
	candy_tracker.visible = false
	self.visible = false
	center_stage.gravity = 0.0
	camera.switch_camera_points(center_stage)
	the_dark.visible = false
	round_over = true
	center_stage.round_playing = false
	candy_tracker.get_child(0).set_one_shot(true)
	await get_tree().create_timer(1.0).timeout
	calculate_scores()
