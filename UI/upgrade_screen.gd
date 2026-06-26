extends Control

@export var upgrades: playerUpgrades = load("res://Player/Upgrades.tres")
@export var cottonCandy: PlayerCottonCandyTotal = load("res://Player/CottonCandyBank.tres")
# @onready var spin_attack: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack"
# @onready var max_spin_power: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power"
# @onready var reduce_spin_decay: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay"
# @onready var cotton_candy_steal: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal"
# @onready var stronger_enemies: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies"
@onready var MaxDamagecost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Cost"
@onready var MaxSpinForcecost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Cost"
@onready var SpinDecaycost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Cost"
@onready var StaminaConsumptioncost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Cost"
@onready var PowerAmplifiercost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Cost"

@onready var levelMaxDamage: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Level"
@onready var levelMaxSpinForce: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Level"
@onready var levelReduceSpinDecay: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Level"
@onready var levelStaminaConsumption: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Level"
@onready var levelPowerAmplifier: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Level"

@onready var buttonMaxDamage: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Button"
@onready var buttonMaxSpinForce: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Button"
@onready var buttonSpinDecay: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Button"
@onready var buttonStaminaConsumption: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Button"
@onready var buttonPowerAmplifier: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Button"

@onready var cotton_candy_label: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy"

@onready var continue_button: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/MarginContainer/Continue Button"

@export_category("Upgrade Values")
@export_group("Spin Attack")
@export var MaxDamageBaseCost: int = 100
@export var MaxDamageMaxLevel: int = 3

@export_group("Max Spin")
@export var MaxSpinForceBaseCost: int = 100
@export var MaxSpinForceMaxLevel: int = 3

@export_group("Spin Decay")
@export var spinDecayBaseCost: int = 100
@export var spinDecayMaxLevel: int = 3

@export_group("Cotton Candy Steal")
@export var StaminaConsumptionBaseCost: int = 100
@export var StaminaConsumptionMaxLevel: int = 3

@export_group("Stronger Enemies")
@export var PowerAmplifierBaseCost: int = 100
@export var PowerAmplifierMaxLevel: int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonMaxDamage.pressed.connect(buyUpgrade.bind(0))
	buttonMaxSpinForce.pressed.connect(buyUpgrade.bind(1))
	buttonSpinDecay.pressed.connect(buyUpgrade.bind(2))
	buttonStaminaConsumption.pressed.connect(buyUpgrade.bind(3))
	buttonPowerAmplifier.pressed.connect(buyUpgrade.bind(4))

	continue_button.pressed.connect(continueGame)

	cottonCandy.cottonCandyChanged.connect(updateCottonCandyAmount)
	cotton_candy_label.text = "Cotton Candy : " + str(cottonCandy.cottonCandyBank)
	evilInitialize()

func continueGame() -> void:
	pass

func evilInitialize() -> void:
	buyMaxDamage(true)
	buyMaxSpinForce(true)
	buySpinDecay(true)
	buyStaminaConsumption(true)
	buyPowerAmplifier(true)

func updateCottonCandyAmount(newamount: int, oldamount: int) -> void:
	print("old candy amount : " + str(oldamount))
	cotton_candy_label.text = "Cotton Candy : " + str(newamount)

func buyUpgrade(index: int) -> void:
	match index:
		0:
			buyMaxDamage()
		1:
			buyMaxSpinForce()
		2:
			buySpinDecay()
		3:
			buyStaminaConsumption()
		4:
			buyPowerAmplifier()
		_:
			return

func matchIndexToUpgrade(index:int) -> int:
	match index:
		0:
			return upgrades.MaxDamage
		1:
			return upgrades.MaxSpinForceForce
		2:
			return upgrades.SpinDecay
		3:
			return upgrades.StaminaConsumption
		4:
			return upgrades.PowerAmplifier
		_:
			return 0

func buyMaxDamage(init:bool = false) -> void:
	var cost: int = MaxDamageBaseCost * (1 + upgrades.MaxDamage)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.MaxDamage = upgrades.upgradeStat(upgrades.MaxDamage)
			# print(upgrades.upgrades.MaxDamage)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = MaxDamageBaseCost * (1 + upgrades.MaxDamage)
	MaxDamagecost.text = str(cost)
	levelMaxDamage.text = "LVL : " + str(upgrades.MaxDamage)
	if (upgrades.MaxDamage >= MaxDamageMaxLevel):
		buttonMaxDamage.disabled = true

func buyMaxSpinForce(init:bool = false) -> void:
	var cost: int = MaxSpinForceBaseCost * (1 + upgrades.MaxSpinForce)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.MaxSpinForce = upgrades.upgradeStat(upgrades.MaxSpinForce)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = MaxDamageBaseCost * (1 + upgrades.MaxSpinForce)
	MaxSpinForcecost.text = str(cost)
	levelMaxSpinForce.text = "LVL : " +  str(upgrades.MaxSpinForce)
	if (upgrades.MaxSpinForce >= MaxSpinForceMaxLevel):
		buttonMaxSpinForce.disabled = true


func buySpinDecay(init:bool = false) -> void:
	var cost: int = spinDecayBaseCost * (1 + upgrades.SpinDecay)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.SpinDecay = upgrades.upgradeStat(upgrades.SpinDecay)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = MaxDamageBaseCost * (1 + upgrades.SpinDecay)
	SpinDecaycost.text = str(cost)
	levelReduceSpinDecay.text = "LVL : " + str(upgrades.SpinDecay)
	if (upgrades.SpinDecay >= spinDecayMaxLevel):
		buttonSpinDecay.disabled = true


func buyStaminaConsumption(init:bool = false) -> void:
	var cost: int = StaminaConsumptionBaseCost * (1 + upgrades.StaminaConsumption)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.StaminaConsumption = upgrades.upgradeStat(upgrades.StaminaConsumption)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = MaxDamageBaseCost * (1 + upgrades.StaminaConsumption)
	StaminaConsumptioncost.text = str(cost)
	levelStaminaConsumption.text = "LVL : " + str(upgrades.StaminaConsumption)
	if (upgrades.StaminaConsumption >= StaminaConsumptionMaxLevel):
		buttonStaminaConsumption.disabled = true


func buyPowerAmplifier(init:bool = false) -> void:
	var cost: int = PowerAmplifierBaseCost * (1 + upgrades.PowerAmplifier)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.PowerAmplifier = upgrades.upgradeStat(upgrades.PowerAmplifier)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = MaxDamageBaseCost * (1 + upgrades.PowerAmplifier)
	PowerAmplifiercost.text = str(cost)	
	levelPowerAmplifier.text = "LVL : " + str(upgrades.PowerAmplifier)
	if (upgrades.PowerAmplifier >= PowerAmplifierMaxLevel):
		buttonPowerAmplifier.disabled = true



# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
