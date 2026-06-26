extends Control

@export var upgrades: playerUpgrades = load("res://Player/Upgrades.tres")
@export var cottonCandy: PlayerCottonCandyTotal = load("res://Player/CottonCandyBank.tres")
# @onready var spin_attack: HBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Potential Damage"
# @onready var max_spin_power: HBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Max Spin Force"
# @onready var reduce_spin_decay: HBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Spin Decay"
# @onready var cotton_candy_steal: HBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Stamina"
# @onready var stronger_enemies: HBoxContainer = $"PanelContainer/MarginContainer/VBoxContainer/Speed Amplifier"
@onready var MaxSpinForcecost: Label = $"PanelContainer/MarginContainer/VBoxContainer/Max Spin Force/Cost"
@onready var SpinDecaycost: Label = $"PanelContainer/MarginContainer/VBoxContainer/Spin Decay/Cost"
@onready var MaxDamagecost: Label = $"PanelContainer/MarginContainer/VBoxContainer/Potential Damage/Cost"
@onready var StaminaConsumptioncost: Label = $"PanelContainer/MarginContainer/VBoxContainer/Stamina/Cost"
@onready var PowerAmplifiercost: Label = $"PanelContainer/MarginContainer/VBoxContainer/Speed Amplifier/Cost"
@onready var CandyMultipliercost: Label = $"PanelContainer/MarginContainer/VBoxContainer/Candy Multiplier/Cost"

@onready var levelMaxSpinForce: Label = $"PanelContainer/MarginContainer/VBoxContainer/Max Spin Force/Level"
@onready var levelReduceSpinDecay: Label = $"PanelContainer/MarginContainer/VBoxContainer/Spin Decay/Level"
@onready var levelMaxDamage: Label = $"PanelContainer/MarginContainer/VBoxContainer/Potential Damage/Level"
@onready var levelStaminaConsumption: Label = $"PanelContainer/MarginContainer/VBoxContainer/Stamina/Level"
@onready var levelPowerAmplifier: Label = $"PanelContainer/MarginContainer/VBoxContainer/Speed Amplifier/Level"
@onready var levelCandyMultiplier: Label = $"PanelContainer/MarginContainer/VBoxContainer/Candy Multiplier/Level"

@onready var buttonMaxSpinForce: Button = $"PanelContainer/MarginContainer/VBoxContainer/Max Spin Force/Button"
@onready var buttonSpinDecay: Button = $"PanelContainer/MarginContainer/VBoxContainer/Spin Decay/Button"
@onready var buttonMaxDamage: Button = $"PanelContainer/MarginContainer/VBoxContainer/Potential Damage/Button"
@onready var buttonStaminaConsumption: Button = $"PanelContainer/MarginContainer/VBoxContainer/Stamina/Button"
@onready var buttonPowerAmplifier: Button = $"PanelContainer/MarginContainer/VBoxContainer/Speed Amplifier/Button"
@onready var buttonCandyMultiplier: Button = $"PanelContainer/MarginContainer/VBoxContainer/Candy Multiplier/Button"

@onready var cotton_candy_label: Label = $"PanelContainer/MarginContainer/VBoxContainer/Cotton Candy"

@onready var continue_button: Button = $"PanelContainer/MarginContainer/MarginContainer/HBoxContainer/Continue Button"
@onready var main_menu_button: Button = $"PanelContainer/MarginContainer/MarginContainer/HBoxContainer/MainMenu Button"

@export_category("Upgrade Values")
@export_group("Max Spin Force")
@export var MaxSpinForceBaseCost: int = 100
@export var MaxSpinForceMaxLevel: int = 3

@export_group("Spin Decay")
@export var spinDecayBaseCost: int = 100
@export var spinDecayMaxLevel: int = 3

@export_group("Potential Damage")
@export var MaxDamageBaseCost: int = 100
@export var MaxDamageMaxLevel: int = 3

@export_group("Stamina")
@export var StaminaConsumptionBaseCost: int = 100
@export var StaminaConsumptionMaxLevel: int = 3

@export_group("Speed Amplifier")
@export var PowerAmplifierBaseCost: int = 100
@export var PowerAmplifierMaxLevel: int = 3

@export_group("Candy Multiplier")
@export var CandyMultiplierBaseCost: int = 100
@export var CandyMultiplierMaxLevel: int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonMaxSpinForce.pressed.connect(buyUpgrade.bind(0))
	buttonSpinDecay.pressed.connect(buyUpgrade.bind(1))
	buttonMaxDamage.pressed.connect(buyUpgrade.bind(2))
	buttonStaminaConsumption.pressed.connect(buyUpgrade.bind(3))
	buttonPowerAmplifier.pressed.connect(buyUpgrade.bind(4))
	buttonCandyMultiplier.pressed.connect(buyUpgrade.bind(5))

	continue_button.pressed.connect(continueGame)
	main_menu_button.pressed.connect(mainMenu)

	cottonCandy.cottonCandyChanged.connect(updateCottonCandyAmount)
	cotton_candy_label.text = "Cotton Candy : " + str(cottonCandy.cottonCandyBank)
	evilInitialize()

func continueGame() -> void:
	var main_game = "res://main_game.tscn"
	get_tree().change_scene_to_file(main_game)
	
func mainMenu() -> void:
	var main_menu = "res://UI/MainMenu.tscn"
	get_tree().change_scene_to_file(main_menu)

func evilInitialize() -> void:
	buyMaxSpinForce(true)
	buySpinDecay(true)
	buyMaxDamage(true)
	buyStaminaConsumption(true)
	buyPowerAmplifier(true)
	buyCandyMultiplier(true)

func updateCottonCandyAmount(newamount: int, oldamount: int) -> void:
	print("old candy amount : " + str(oldamount))
	cotton_candy_label.text = "Cotton Candy : " + str(newamount)

func buyUpgrade(index: int) -> void:
	match index:
		0:
			buyMaxSpinForce()
		1:
			buySpinDecay()
		2:
			buyMaxDamage()
		3:
			buyStaminaConsumption()
		4:
			buyPowerAmplifier()
		5:
			buyCandyMultiplier()
		_:
			return

func matchIndexToUpgrade(index:int) -> int:
	match index:
		0:
			return upgrades.MaxSpinForce
		1:
			return upgrades.SpinDecay
		2:
			return upgrades.MaxDamage
		3:
			return upgrades.StaminaConsumption
		4:
			return upgrades.PowerAmplifier
		5:
			return upgrades.CandyMultiplier
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
	cost = MaxSpinForceBaseCost * (1 + upgrades.MaxSpinForce)
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
	cost = spinDecayBaseCost * (1 + upgrades.SpinDecay)
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
	cost = StaminaConsumptionBaseCost * (1 + upgrades.StaminaConsumption)
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
	cost = PowerAmplifierBaseCost * (1 + upgrades.PowerAmplifier)
	PowerAmplifiercost.text = str(cost)	
	levelPowerAmplifier.text = "LVL : " + str(upgrades.PowerAmplifier)
	if (upgrades.PowerAmplifier >= PowerAmplifierMaxLevel):
		buttonPowerAmplifier.disabled = true

func buyCandyMultiplier(init:bool = false) -> void:
	var cost: int = CandyMultiplierBaseCost * (1 + upgrades.CandyMultiplier)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.CandyMultiplier = upgrades.upgradeStat(upgrades.CandyMultiplier)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = CandyMultiplierBaseCost * (1 + upgrades.CandyMultiplier)
	CandyMultipliercost.text = str(cost)	
	levelCandyMultiplier.text = "LVL : " + str(upgrades.CandyMultiplier)
	if (upgrades.CandyMultiplier >= CandyMultiplierMaxLevel):
		buttonCandyMultiplier.disabled = true

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
