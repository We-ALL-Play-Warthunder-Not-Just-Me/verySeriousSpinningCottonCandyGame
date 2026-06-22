extends Resource
## Store the level of player upgrades
class_name playerUpgrades

# So keep track of upgrades by it's lvl ie if the upgrade is lvl 1 or 2 or 3

## Makes your Top bigger, hit enemies harder and take more spin and candy from them, but you are also a bigger target
@export var SpinAttack: int = 0
## Increases max spin power (max HP)
@export var MaxSpinPower: int = 0
## Decreases the decay of your spin (health decay)
@export var ReduceSpinDecayRate: int = 0
## Increases the cotton candy you steal from hitting enemies
@export var CottonCandyStealPower: int = 0
## Makes the enemies stronger, stronger enemies drop more cotton candy
@export var StrongerEnemies: int = 0
## Generic level cap for all the upgrades
@export var maxLVL: int = 3

func upgradeStat(stat: int) -> void:
	if stat < maxLVL :
		stat += 1
