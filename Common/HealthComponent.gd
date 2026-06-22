extends Node
class_name HealthComponent

@export_range(0, 100, 1, "or_greater", "prefer_slider") var MaxHp: int = 100
@export_range(0, 100, 1, "or_greater", "prefer_slider") var CurrentHP: int = 100
@export_range(0, 100, 1, "or_greater", "prefer_slider") var HealthDecay: int = 5
# We lose spin every few thingies


signal CurrenthealthChanged(newHP: int, OldHP: int)
signal MaxHpChanged(newMax: int, oldMax: int)
signal healthDEATH()

func setCurrenthp(newHP: int) -> void:
	var old: int = CurrentHP
	CurrentHP = newHP
	CurrenthealthChanged.emit(CurrentHP,old)

func setMaxHP(newHP: int) -> void:
	var old: int = MaxHp
	MaxHp = newHP
	MaxHpChanged.emit(MaxHp, old)

func takeDamage(damage: int) -> void:
	var old: int = CurrentHP
	CurrentHP -= damage
	if CurrentHP <= 0:
		healthDEATH.emit()
	else:
		CurrenthealthChanged.emit(CurrentHP,old)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
