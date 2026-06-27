extends VBoxContainer

@onready var how_to_play: Button = $HowToPlay
@onready var start: Button = $Start
@onready var settings: Button = $Settings
@onready var credits: Button = $Credits
@onready var quit: Button = $Quit

@onready var settings_screen: Control = $"../../../../SettingsScreen"
@onready var credits_screen: Control =  $"../../../../Credits"
@onready var how_to_screen: Control =  $"../../../../HowToPlay"
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_how_to_play_pressed() -> void:
	how_to_screen.show()

func _on_start_pressed() -> void:
	var main_game = "res://main_game.tscn"
	get_tree().change_scene_to_file(main_game)

func _on_settings_pressed() -> void:
	settings_screen.show()

func _on_credits_pressed() -> void:
	credits_screen.show()

func _on_quit_pressed() -> void:
	get_tree().quit()
