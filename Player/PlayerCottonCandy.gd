extends Resource

## This is the amount of cotton candy the player has that they can spend at the upgrades store
class_name PlayerCottonCandyTotal

@export_range(0, 999, 1, "or_greater") var cottonCandyBank : int

signal cottonCandyChanged(newamount:int, oldamount:int)

func addCottonCandy(amount: int) -> void:
	var old: int = cottonCandyBank
	cottonCandyBank += amount
	cottonCandyChanged.emit(cottonCandyBank, old)

func removeCottonCandy(amount: int) -> void:
	var old: int = cottonCandyBank
	cottonCandyBank -= amount
	if cottonCandyBank < 0:
		cottonCandyBank = 0
	cottonCandyChanged.emit(cottonCandyBank, old)
