extends Resource
## Store the level of player upgrades
class_name playerUpgrades

# So keep track of upgrades by it's lvl ie if the upgrade is lvl 1 or 2 or 3

## Increases max spin force (max HP) (default 75)
@export var MaxSpinForce: int = 0
## Decreases the decay of your spin (health decay) (default 5.0)
@export var ReduceSpinDecayRate: int = 0
## Increases your cap on how much damage you can do to enemies (default 15)
@export var MaxSpinStealDamage: int = 0
## Decreases how much stamina you take from the dash meter (default 30)
@export var ReduceStaminaConsumption: int = 0
## Increases your amplifier so you can launch even faster with each dash (default 3.0)
@export var PowerAmplifier: int = 0
## Increases how much candy you can get per spin cycle. Is affected by your health (default 3)
@export var CandyMultiplier: int = 0
## Generic level cap for all the upgrades
@export var maxLVL: int = 3

signal statChanged()

func upgradeStat(stat: int) -> void:
	if stat < maxLVL :
		stat += 1
		statChanged.emit()
