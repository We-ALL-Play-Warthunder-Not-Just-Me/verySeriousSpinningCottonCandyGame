extends Label

@onready var countdown = $Timer
@onready var round_over_text = $Finished
@onready var center_stage = get_node("/root/MainGame/CenterStage")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(countdown.time_left)
	self.text = str(ceili(countdown.time_left))

func round_end():
	round_over_text.visible = true
	center_stage.round_playing = false
	pass
