extends Node

@export_category("Rotator Stats")
@export var max_launch_speed: int
@export var max_safe_speed: int
@export var bounce_power: int
@export var health: int
@export var power: int

var direction: Vector2 = Vector2.ZERO
var speed: int = 0

var current_state: STATE = STATE.GLIDING 
#var parry_time: float = 10
enum STATE{
	PARRYING,
	GLIDING,
	DASHING
}


func _process(delta: float) -> void:
	var i = 0


func Movement(direction: Vector2, speed: int):
	var i = 0
	
