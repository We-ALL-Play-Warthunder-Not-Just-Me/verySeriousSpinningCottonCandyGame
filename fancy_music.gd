extends AudioStreamPlayer2D

@export var center_stage: Node2D
@export var game_time: Timer
@export var stream_res: AudioStreamInteractive

func _process(_delta: float) -> void:
	var playing_clip_name = get_stream_playback().get_current_clip_index()
	if game_time.time_left < 44 and center_stage.round_playing:
		stream_res.set_clip_auto_advance_next_clip(playing_clip_name, 3)
	
