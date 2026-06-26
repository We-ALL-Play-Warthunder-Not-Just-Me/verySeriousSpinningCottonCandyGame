extends Node

## Right now this applies upgrades to the player, currently only max health (MaxSpinForce)
class_name upgrade_manager

@export var upgrades: playerUpgrades = load("res://Player/Upgrades.tres")
@export var health: HealthComponent 

@export_category("Stat Gained Per Level")
# assuming each upgrade level is 50 max health each
@export var MaxSpinForceLvlValue: int = 25
@export var SpinDecayLvlValue: int = 2
@export var MaxDamageLvlValue : int = 10
@export var StaminaConsumptionLvlValue: int = 5
@export var PowerAmplifierLvlValue: float = 1.0
@export var CandyMultiplierLvlValue: int = 3

@export_category("Starting Stats")
@export var startMaxSpinForce: int = 75
@export var startSpinDecay: int = 8
@export var startMaxDamage: int = 15
@export var startStaminaConsumption: int = 30
@export var startPowerAmplifier: float = 3.0
@export var startCandyMultiplier: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if upgrades == null:
		upgrades = playerUpgrades.new()
		ResourceSaver.save(upgrades, "res://Player/Upgrades.tres")
	upgrades.statChanged.connect(applyTheStats)
	applyTheStats()
	
func applyTheStats() -> void:
	applyMaxSpinForceUpgrade()
	applySpinDecayUpgrade()
	applyMaxDamageUpgrade()
	applyStaminaConsumptionUpgrade()
	applyPowerAmplifier()
	applyCandyMultiplier()

func applyMaxSpinForceUpgrade() -> void:
	var MaxSpinForcetoApply: int = 0
	if upgrades.MaxSpinForce == 0:
		return
	for i: int in upgrades.MaxSpinForce:
		MaxSpinForcetoApply += MaxSpinForceLvlValue
	health.setMaxHP(startMaxSpinForce + MaxSpinForcetoApply) # assuming base starting health is 100, for cases where this function gets called multiple times ie: the upgrade shop

func applySpinDecayUpgrade() -> void:
	var spinDecaytoApply: int = 0
	if upgrades.SpinDecay == 0:
		return
	for i: int in upgrades.SpinDecay:
		spinDecaytoApply += SpinDecayLvlValue
	health.HealthDecay = startSpinDecay - spinDecaytoApply # assuming our base starting decay is 10

func applyMaxDamageUpgrade() -> void:
	var MaxDamagetoApply: int = 0
	if upgrades.MaxDamage == 0:
		return
	for i: int in upgrades.MaxDamage:
		MaxDamagetoApply += MaxDamageLvlValue
	health.MaxDamage = startMaxDamage + MaxDamagetoApply

func applyStaminaConsumptionUpgrade() -> void:
	var StaminaConsumptiontoApply: int = 0
	if upgrades.StaminaConsumption == 0:
		return
	for i: int in upgrades.StaminaConsumption:
		StaminaConsumptiontoApply -= StaminaConsumptionLvlValue
	health.StaminaConsumption = startStaminaConsumption + StaminaConsumptiontoApply

func applyPowerAmplifier() -> void:
	var PowerAmplifiertoApply: float = 0
	if upgrades.PowerAmplifier == 0:
		return
	for i: int in upgrades.PowerAmplifier:
		PowerAmplifiertoApply += PowerAmplifierLvlValue
	health.PowerAmplifier = startPowerAmplifier + PowerAmplifiertoApply

func applyCandyMultiplier() -> void:
	var CandyMultipliertoApply: int = 0
	if upgrades.CandyMultiplier == 0:
		return
	for i: int in upgrades.CandyMultiplier:
		CandyMultipliertoApply += CandyMultiplierLvlValue
	health.CandyMultiplier = startCandyMultiplier + CandyMultipliertoApply
