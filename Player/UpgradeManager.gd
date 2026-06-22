extends Node

class_name upgrade_manager

@export var upgrades: playerUpgrades = load("res://Player/Upgrades.tres")
@export var health: HealthComponent 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if upgrades == null:
		upgrades.new()
		ResourceSaver.save(upgrades, "res://Player/Upgrades.tres")
	applySpinAttackUpgrade()
	applyMaxSpinPowerUpgrade()
	applyReduceSpinDecayRateUpgrade()
	applyCottonCandyStealPowerUpgrade()
	

func applySpinAttackUpgrade() -> void:
	pass

# assuming each upgrade level is 50 max health each
var maxHPlvlValue: int = 50
func applyMaxSpinPowerUpgrade() -> void:
	var maxHPtoApply: int = 0
	if upgrades.MaxSpinPower == 0:
		return
	for i: int in upgrades.MaxSpinPower:
		maxHPtoApply += maxHPlvlValue
	health.setMaxHP(100 + maxHPtoApply) # assuming base starting health is 100, for cases where this function gets called multiple times ie: the upgrade shop

func applyReduceSpinDecayRateUpgrade() -> void:
	pass

func applyCottonCandyStealPowerUpgrade() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
