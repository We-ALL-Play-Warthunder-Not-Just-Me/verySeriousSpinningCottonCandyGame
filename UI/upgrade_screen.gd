extends Control

@export var upgrades: playerUpgrades = load("res://Player/Upgrades.tres")
@export var cottonCandy: PlayerCottonCandyTotal = load("res://Player/CottonCandyBank.tres")
# @onready var spin_attack: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack"
# @onready var max_spin_power: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power"
# @onready var reduce_spin_decay: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay"
# @onready var cotton_candy_steal: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal"
# @onready var stronger_enemies: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies"
@onready var MaxSpinStealDamagecost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Cost"
@onready var MaxSpincost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Cost"
@onready var SpinDecaycost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Cost"
@onready var ReduceStaminaConsumptioncost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Cost"
@onready var PowerAmplifiercost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Cost"

@onready var levelMaxSpinStealDamage: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Level"
@onready var levelMaxSpinForce: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Level"
@onready var levelReduceSpinDecay: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Level"
@onready var levelReduceStaminaConsumption: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Level"
@onready var levelPowerAmplifier: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Level"

@onready var buttonMaxSpinStealDamage: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Button"
@onready var buttonMaxSpinForce: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Button"
@onready var buttonSpinDecay: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Button"
@onready var buttonCottonCandySteal: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Button"
@onready var buttonPowerAmplifier: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Button"

@onready var cotton_candy_label: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy"

@onready var continue_button: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/MarginContainer/Continue Button"

@export_category("Upgrade Values")
@export_group("Spin Attack")
@export var spinAttackBaseCost: int = 100
@export var spinAttackMaxLevel: int = 3

@export_group("Max Spin")
@export var maxSpinBaseCost: int = 100
@export var maxspinMaxLevel: int = 3

@export_group("Spin Decay")
@export var spinDecayBaseCost: int = 100
@export var spinDecayMaxLevel: int = 3

@export_group("Cotton Candy Steal")
@export var cottonCandyStealBaseCost: int = 100
@export var cottonCandyStealMaxLevel: int = 3

@export_group("Stronger Enemies")
@export var PowerAmplifierBaseCost: int = 100
@export var PowerAmplifierMaxLevel: int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonMaxSpinStealDamage.pressed.connect(buyUpgrade.bind(0))
	buttonMaxSpinForce.pressed.connect(buyUpgrade.bind(1))
	buttonSpinDecay.pressed.connect(buyUpgrade.bind(2))
	buttonCottonCandySteal.pressed.connect(buyUpgrade.bind(3))
	buttonPowerAmplifier.pressed.connect(buyUpgrade.bind(4))

	continue_button.pressed.connect(continueGame)

	cottonCandy.cottonCandyChanged.connect(updateCottonCandyAmount)
	cotton_candy_label.text = "Cotton Candy : " + str(cottonCandy.cottonCandyBank)
	evilInitialize()

func continueGame() -> void:
	pass

func evilInitialize() -> void:
	buyMaxSpinStealDamage(true)
	buyMaxSpin(true)
	buySpinDecay(true)
	buyReduceStamina(true)
	buyPowerAmplifier(true)

func updateCottonCandyAmount(newamount: int, oldamount: int) -> void:
	print("old candy amount : " + str(oldamount))
	cotton_candy_label.text = "Cotton Candy : " + str(newamount)

func buyUpgrade(index: int) -> void:
	match index:
		0:
			buyMaxSpinStealDamage()
		1:
			buyMaxSpin()
		2:
			buySpinDecay()
		3:
			buyReduceStamina()
		4:
			buyPowerAmplifier()
		_:
			return

func matchIndexToUpgrade(index:int) -> int:
	match index:
		0:
			return upgrades.MaxSpinStealDamage
		1:
			return upgrades.MaxSpinForce
		2:
			return upgrades.ReduceSpinDecayRate
		3:
			return upgrades.ReduceStaminaConsumption
		4:
			return upgrades.PowerAmplifier
		_:
			return 0

func buyMaxSpinStealDamage(init:bool = false) -> void:
	var cost: int = spinAttackBaseCost * (1 + upgrades.MaxSpinStealDamage)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.SpinAttack = upgrades.upgradeStat(upgrades.MaxSpinStealDamage)
			# print(upgrades.upgrades.MaxSpinStealDamage)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.MaxSpinStealDamage)
	MaxSpinStealDamagecost.text = str(cost)
	levelMaxSpinStealDamage.text = "LVL : " + str(upgrades.MaxSpinStealDamage)
	if (upgrades.MaxSpinStealDamage >= spinAttackMaxLevel):
		buttonMaxSpinStealDamage.disabled = true

func buyMaxSpin(init:bool = false) -> void:
	var cost: int = maxSpinBaseCost * (1 + upgrades.MaxSpinForce)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.MaxSpinPower = upgrades.upgradeStat(upgrades.MaxSpinForce)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.MaxSpinForce)
	MaxSpincost.text = str(cost)
	levelMaxSpinForce.text = "LVL : " +  str(upgrades.MaxSpinForce)
	if (upgrades.MaxSpinForce >= maxspinMaxLevel):
		buttonMaxSpinForce.disabled = true


func buySpinDecay(init:bool = false) -> void:
	var cost: int = spinDecayBaseCost * (1 + upgrades.ReduceSpinDecayRate)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.ReduceSpinDecayRate = upgrades.upgradeStat(upgrades.ReduceSpinDecayRate)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.ReduceSpinDecayRate)
	SpinDecaycost.text = str(cost)
	levelReduceSpinDecay.text = "LVL : " + str(upgrades.ReduceSpinDecayRate)
	if (upgrades.ReduceSpinDecayRate >= spinDecayMaxLevel):
		buttonSpinDecay.disabled = true


func buyReduceStamina(init:bool = false) -> void:
	var cost: int = cottonCandyStealBaseCost * (1 + upgrades.ReduceStaminaConsumption)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.ReduceStaminaConsumption = upgrades.upgradeStat(upgrades.ReduceStaminaConsumption)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.ReduceStaminaConsumption)
	ReduceStaminaConsumptioncost.text = str(cost)
	levelReduceStaminaConsumption.text = "LVL : " + str(upgrades.ReduceStaminaConsumption)
	if (upgrades.ReduceStaminaConsumption >= cottonCandyStealMaxLevel):
		buttonCottonCandySteal.disabled = true


func buyPowerAmplifier(init:bool = false) -> void:
	var cost: int = PowerAmplifierBaseCost * (1 + upgrades.PowerAmplifier)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.PowerAmplifier = upgrades.upgradeStat(upgrades.PowerAmplifier)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.PowerAmplifier)
	PowerAmplifiercost.text = str(cost)	
	levelPowerAmplifier.text = "LVL : " + str(upgrades.PowerAmplifier)
	if (upgrades.PowerAmplifier >= PowerAmplifierMaxLevel):
		buttonPowerAmplifier.disabled = true



# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
