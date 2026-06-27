extends Control

@export var back_button: Button

func _ready() -> void:
	back_button.pressed.connect(close)

func close():
	hide()
