extends Control

@onready var masterVolSlider: HSlider = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer/master
@onready var musicVolSlider: HSlider = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/music
@onready var sfxVolSlider: HSlider = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer3/sfx

@onready var back_button: Button = $TextureRect/MarginContainer/VBoxContainer/BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Settings.master_volume_updated.connect(master_volume_signal)
	Settings.music_volume_updated.connect(music_volume_signal)
	Settings.sfx_volume_updated.connect(sfx_volume_signal)
	back_button.pressed.connect(backButtonPressed)

	Settings.loadData()


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass

func backButtonPressed() -> void:
	Settings.saveData()
	hide()

func master_volume_signal(value: float) -> void:
	masterVolSlider.value = value

func music_volume_signal(value: float) -> void:
	musicVolSlider.value = value

func sfx_volume_signal(value: float) -> void:
	sfxVolSlider.value = value

func _on_master_value_changed(value: float) -> void:
	Settings.master_vol = value

func _on_music_value_changed(value: float) -> void:
	Settings.music_vol = value

func _on_sfx_value_changed(value: float) -> void:
	Settings.sfx_vol = value
