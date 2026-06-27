extends Node
class_name HealthComponent

#Health Related Stuff
@export_range(0, 200, 1, "or_greater", "prefer_slider") var MaxHP: int = 100
@export_range(0, 200, 1, "or_greater", "prefer_slider") var CurrentHP: int = 100
@export_range(0, 100, 1, "or_greater", "prefer_slider") var HealthDecay: int = 8

#Other Stats for storing purposes
@export_range(0, 100, 1, "or_greater", "prefer_slider") var max_power: int = 60
@export_range(0, 100, 1, "or_greater", "prefer_slider") var MaxDamage: int = 15
@export_range(0, 50, 1, "or_greater", "prefer_slider") var StaminaConsumption: int = 30
@export_range(0, 10.0, 0.1, "or_greater", "prefer_slider") var PowerAmplifier: float = 3.0
@export_range(0, 20, 1, "or_greater", "prefer_slider") var CandyMultiplier: int = 3
@export_range(0, 100, 1, "or_greater", "prefer_slider") var TakedownReward: int = 30
@export_range(0, 10.0, 0.1, "or_greater", "prefer_slider") var DashDuration: float = 2.0
@export_range(0, 10.0, 0.1, "or_greater", "prefer_slider") var ParryDuration: float = 0.5
@export_range(0, 10.0, 0.1, "or_greater", "prefer_slider") var ParryStart: float = 0.5
@export_range(0, 1.0, 0.01, "or_greater", "prefer_slider") var SpeedDamageMin: float = 0.75
# We lose spin every few thingies

signal CurrenthealthChanged(newHP: int, OldHP: int)
signal MaxHPChanged(newMax: int, oldMax: int)
signal healthDEATH()

func setCurrenthp(newHP: int) -> void:
	var old: int = CurrentHP
	CurrentHP = newHP
	if CurrentHP <= 0:
		healthDEATH.emit()
	CurrenthealthChanged.emit(CurrentHP,old)

func setMaxHP(newHP: int) -> void:
	var old: int = MaxHP
	MaxHP = newHP
	MaxHPChanged.emit(MaxHP, old)

func takeDamage(damage: int) -> void:
	var old: int = CurrentHP
	CurrentHP -= damage
	if CurrentHP <= 0:
		healthDEATH.emit()
	else:
		CurrenthealthChanged.emit(CurrentHP,old)

func heal(healAmount: int) -> void:
	var old : int = CurrentHP
	if (CurrentHP + healAmount < MaxHP):
		CurrentHP += healAmount
		CurrenthealthChanged.emit(CurrentHP,old)
	elif (CurrentHP + healAmount >= MaxHP):
		CurrentHP = MaxHP
		CurrenthealthChanged.emit(CurrentHP,old)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
