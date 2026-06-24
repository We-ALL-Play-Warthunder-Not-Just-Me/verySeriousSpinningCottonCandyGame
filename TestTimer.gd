extends Label

@onready var countdown = $Timer
@onready var round_over_text = $EndText
@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var candy_tracker = get_node("/root/MainGame/CottonCandyTracker")
var final_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(countdown.time_left)
	self.text = str(ceili(countdown.time_left))

func calculate_scores():
	final_text = "[b]FIN[/b]"
	for player in candy_tracker.spinners_dictionary:
		var score_candy = "\n" + player + " Candy: " + str(candy_tracker.spinners_dictionary[player])
		final_text += score_candy
	round_over_text.append_text(final_text)
	round_over_text.visible = true

func round_end():
	center_stage.round_playing = false
	candy_tracker.get_child(0).set_one_shot(true)
	await get_tree().create_timer(1.0).timeout
	calculate_scores()
