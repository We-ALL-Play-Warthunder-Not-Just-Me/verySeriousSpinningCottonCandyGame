extends Label

@onready var countdown = $Timer
@onready var the_dark = get_node("/root/MainGame/TheDark")
@onready var round_over_text = get_node("/root/MainGame/CanvasLayer/EndText")
@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var candy_tracker = get_node("/root/MainGame/CanvasLayer/CottonCandyTracker")
@onready var camera = get_node("/root/MainGame/FancyCamera")
@onready var black_screen = get_node("/root/MainGame/CanvasLayer/BlackBox")
@export var candy_bank: PlayerCottonCandyTotal = load("res://Player/CottonCandyBank.tres")
var respawn_countdown = 0
var final_text
var round_over = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(countdown.time_left)
	self.text = str(ceili(countdown.time_left))
	if round_over == true:
		if Input.is_action_just_pressed("ui_accept"):
			var level_fqn = "res://UI/UpgradeScreen.tscn"
			get_tree().change_scene_to_file(level_fqn)
	else:
		if !camera.follow_player and respawn_countdown > 0:
			respawn_countdown -= delta
			round_over_text.clear()
			final_text = "[outline_size={32}][b]" + str(ceili(respawn_countdown)) + "[/b][/outline_size]"
			round_over_text.append_text(final_text)
			round_over_text.visible = true
		elif camera.follow_player:
			respawn_countdown = 5
			round_over_text.visible = false
		

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
				multiplier_display = "[pulse freq=5.0 color=ffe737 ease=-0.5][color=fec9ed][outline_color=cf3c71][font_size={56}]\n\nPlayer gets a multiplier of: " + str(win_multiplier)
			elif placement == 2:
				win_multiplier = 1.5
				multiplier_display = "[pulse freq=4.0 color=6a31ca ease=-0.5][color=cc69e4][outline_color=00177d][font_size={56}]\n\nPlayer gets a multiplier of: " + str(win_multiplier)
			elif placement == 3:
				win_multiplier = 1.0
				multiplier_display = "[pulse freq=3.0 color=0a89ff ease=-0.5][color=6264dc][outline_color=211640][font_size={56}]\n\nPlayer gets a multiplier of: " + str(win_multiplier) 
			elif placement == 4:
				win_multiplier = 0.5
				multiplier_display = "[pulse freq=3.0 color=cf3c71 ease=-0.5][color=e03c28][outline_color=4f1507][font_size={56}]\n\nYour Candy Multiplier: " + str(win_multiplier)
	final_text += multiplier_display + "[/font_size][/outline_color][/color][/pulse]"
	final_text += "[wave amp=50.0 freq=5.0 connected=1]\n\nPress Space to continue to Shop![/wave]"
	round_over_text.append_text(final_text)
	black_screen.visible = true
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
	respawn_countdown = 0
	round_over_text.clear()
	await get_tree().create_timer(1.0).timeout
	calculate_scores()
