extends Resource

class_name playerUpgrades

# So keep track of upgrades by it's lvl ie if the upgrade is lvl 1 or 2 or 3

@export var SpinAttack: int = 0
@export var MaxSpinPower: int = 0
@export var ReduceSpinDecayRate: int = 0
@export var CottonCandyStealPower: int = 0
@export var StrongerEnemies: int = 0

@export var maxLVL: int = 3

func upgradeStat(stat: int) -> void:
    if stat < maxLVL :
        stat += 1

