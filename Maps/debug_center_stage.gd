extends Node2D

@onready var gravity_scale_label = get_node("/root/MainGame/DebugUI/GravityScale")
@onready var gravity_on_label = get_node("/root/MainGame/DebugUI/GravityOn")

@export_range(0, 5.0, 0.1, "prefer_slider") var gravity: float = 1.5
var round_playing: bool
var hold_gravity: float
var gravity_on: bool
var base_gravity: float

func _ready() -> void:
	round_playing = true
	gravity_scale_label.text = "Current Gravity: " + str(gravity)
	gravity_on_label.text = "Gravity On: FALSE"
	gravity_on_label.add_theme_color_override("font_color", "e03c28")
	hold_gravity = gravity
	base_gravity = gravity
	gravity = 0.0
	gravity_on = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DebugGravityUp") and gravity <= 5:
		if Input.is_action_pressed("DebugMoreIncrease"): gravity += 1.0
		elif Input.is_action_pressed("DebugIncrease"): gravity += 0.5
		else: gravity += 0.1
		
	if Input.is_action_just_pressed("DebugGravityDown") and gravity >= 0:
		if Input.is_action_pressed("DebugMoreIncrease"): gravity -= 1.0
		elif Input.is_action_pressed("DebugIncrease"): gravity -= 0.5
		else: gravity -= 0.1

	if gravity_on:
		gravity_on_label.text = "Gravity On: TRUE"
		gravity_on_label.add_theme_color_override("font_color", "8cd612")
		gravity_scale_label.text = "Current Gravity: " + str(gravity)
		if gravity <= 0.0:
			gravity = 0.0
			gravity_scale_label.text = "Current Gravity: " + str(gravity)
			hold_gravity = base_gravity
			gravity_on = false
		elif gravity >= 5:
			gravity = 5.0
	else:
		gravity_on_label.text = "Gravity On: FALSE"
		gravity_on_label.add_theme_color_override("font_color", "e03c28")
		if gravity > 0.0:
			gravity_on = true
	
	if Input.is_action_just_pressed("DebugGravityOnOff"):
		if gravity_on:
			hold_gravity = gravity
			gravity = 0.0
			gravity_on = false
		else:
			gravity = hold_gravity
			gravity_on = true
