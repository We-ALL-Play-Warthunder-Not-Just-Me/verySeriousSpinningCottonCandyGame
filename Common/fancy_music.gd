extends AudioStreamPlayer2D

@export var center_stage: Node2D
@export var game_time: Timer
@export var stream_res: AudioStreamInteractive

func _process(_delta: float) -> void:
	var playing_clip_name = get_stream_playback().get_current_clip_index()
	if center_stage.round_playing and game_time.time_left < 5:
		stream_res.set_clip_auto_advance_next_clip(playing_clip_name, 3)
	
