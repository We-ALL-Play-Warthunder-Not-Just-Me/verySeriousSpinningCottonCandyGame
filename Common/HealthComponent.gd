extends Node
class_name HealthComponent

@export var MaxHp: int = 100
@export var CurrentHP: int = 100


signal CurrenthealthChanged(newHP, OldHP)
signal MaxHpChanged(newMax, oldMax)
signal healthDEATH()

func setCurrenthp(newHP: int) -> void:
	var temp: int = CurrentHP
	CurrentHP = newHP
	CurrenthealthChanged.emit(CurrentHP,temp)

func setMaxHP(newHP: int) -> void:
	var temp: int = MaxHp
	MaxHp = newHP
	MaxHpChanged.emit(MaxHp, temp)

func takeDamage(damage: int) -> void:
	var temp: int = CurrentHP
	CurrentHP -= damage
	if CurrentHP <= 0:
		healthDEATH.emit()
	else:
		CurrenthealthChanged.emit(CurrentHP,temp)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
