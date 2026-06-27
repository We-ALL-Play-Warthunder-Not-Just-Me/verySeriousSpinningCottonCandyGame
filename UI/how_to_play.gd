extends Control

@onready var menu_button: Button = $"TextureRect/MarginContainer/The Beast/Buttons/Menu"
@onready var previous_button: Button = $"TextureRect/MarginContainer/The Beast/Buttons/Previous"
@onready var next_button: Button = $"TextureRect/MarginContainer/The Beast/Buttons/Next"
@onready var pages: TabContainer = $"TextureRect/MarginContainer/The Beast/Pages"

func _ready() -> void:
	menu_button.pressed.connect(close)
	next_button.pressed.connect(next_page)
	previous_button.pressed.connect(previous_page)
	toggle_buttons()

func next_page():
	var page_count = pages.get_tab_count() - 1
	var current_tab = pages.get_current_tab()
	if current_tab < page_count:
		pages.set_current_tab(current_tab+1)
	toggle_buttons()

func previous_page():
	var current_tab = pages.get_current_tab()
	if current_tab > 0:
		pages.set_current_tab(current_tab-1)
	toggle_buttons()

func toggle_buttons():
	var page_count = pages.get_tab_count() - 1
	var current_tab = pages.get_current_tab()
	if current_tab == page_count:
		previous_button.set_disabled(false)
		next_button.set_disabled(true)
	elif current_tab == 0:
		previous_button.set_disabled(true)
		next_button.set_disabled(false)
	else:
		previous_button.set_disabled(false)
		next_button.set_disabled(false)

func close():
	hide()
