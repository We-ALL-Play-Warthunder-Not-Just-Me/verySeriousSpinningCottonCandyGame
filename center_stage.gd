extends Node2D

@export var gravity = 0.0
var round_playing = true

func _process(delta: float) -> void:
	if round_playing == false and gravity > 0.0:
		gravity -= delta
