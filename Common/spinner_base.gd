extends RigidBody2D

@export_category("Enemy Stats")
@export var max_power = 50
@export var min_power = 25
@export var max_amplifier = 4.0
@export var max_candy_multiplier = 5
@export var candy_reducer = 0.6
@export var max_damage = 13
@export var max_health_override = 125
@export var health_decay_override = 6
@export var max_wait_time = 2.5
@export var min_wait_time = 0.75

@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var spawner = get_node("/root/MainGame/Spawner")
@onready var spinners = get_node("..")
@onready var health_bar = $HealthBar
@onready var health = $HealthComponent
@onready var dash_graphic = $VerySeriousDash
@onready var animations = $VerySeriousEnemy/EnemyAnimations
@onready var sfx = get_node("/root/MainGame/FancyCamera/SFX")
var final_wait_time
var previous_frame: Vector2
var amplifier
var candy_multiplier
var dash_time = 3
var dash_countdown
var can_dash = true
var hold_decay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
