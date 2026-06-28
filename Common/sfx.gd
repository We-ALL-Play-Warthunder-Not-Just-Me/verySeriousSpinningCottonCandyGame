extends AudioStreamPlayer2D

@export var hit_noises = []
@export var death_noises = [AudioStream]
@onready var death_player = $SFX2

func random_hurt_sound():
	var audio = hit_noises.pick_random()
	self.set_stream(audio)
	self.play()

func random_death_sound():
	var audio = death_noises.pick_random()
	death_player.set_stream(audio)
	death_player.play()
