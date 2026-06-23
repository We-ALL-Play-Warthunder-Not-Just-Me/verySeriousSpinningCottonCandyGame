extends Node

## Right now this applies upgrades to the player, currently only max health (maxSpinPower)
class_name upgrade_manager

@export var upgrades: playerUpgrades = load("res://Player/Upgrades.tres")
@export var health: HealthComponent 

@export_category("Stat Gained Per Level")
# assuming each upgrade level is 50 max health each
@export var spinAttackLvlValue : int = 1
@export var maxHPLvlValue: int = 50
@export var reduceSpinDecayLvlValue: int = 1
@export var cottonCandyStealLvlValue: int = 1

@export_category("Starting Stats")
@export var startMaxHP: int = 100
@export var startSpinDecay: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if upgrades == null:
		upgrades = playerUpgrades.new()
		ResourceSaver.save(upgrades, "res://Player/Upgrades.tres")
	upgrades.statChanged.connect(applyTheStats)
	applyTheStats()
	
func applyTheStats() -> void:
	applySpinAttackUpgrade()
	applyMaxSpinPowerUpgrade()
	applyReduceSpinDecayRateUpgrade()
	applyCottonCandyStealPowerUpgrade()

func applySpinAttackUpgrade() -> void:
	pass

func applyMaxSpinPowerUpgrade() -> void:
	var maxHPtoApply: int = 0
	if upgrades.MaxSpinPower == 0:
		return
	for i: int in upgrades.MaxSpinPower:
		maxHPtoApply += maxHPLvlValue
	health.setMaxHP(startMaxHP + maxHPtoApply) # assuming base starting health is 100, for cases where this function gets called multiple times ie: the upgrade shop

func applyReduceSpinDecayRateUpgrade() -> void:
	var spinDecaytoApply: int = 0
	if upgrades.ReduceSpinDecayRate == 0:
		return
	for i: int in upgrades.ReduceSpinDecayRate:
		spinDecaytoApply += reduceSpinDecayLvlValue
	health.HealthDecay = startSpinDecay - spinDecaytoApply # assuming our base starting decay is 10

func applyCottonCandyStealPowerUpgrade() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
