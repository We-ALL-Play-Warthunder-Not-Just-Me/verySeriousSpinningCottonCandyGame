extends Control

@onready var back_button: Button = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/Button

func _ready() -> void:
	back_button.pressed.connect(close)

func close():
	hide()
