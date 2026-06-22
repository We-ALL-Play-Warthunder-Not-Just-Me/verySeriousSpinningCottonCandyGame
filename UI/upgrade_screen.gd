extends Control

@export var upgrades: playerUpgrades = load("res://Player/Upgrades.tres")
@export var cottonCandy: PlayerCottonCandyTotal = load("res://Player/CottonCandyBank.tres")
# @onready var spin_attack: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack"
# @onready var max_spin_power: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power"
# @onready var reduce_spin_decay: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay"
# @onready var cotton_candy_steal: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal"
# @onready var stronger_enemies: HBoxContainer = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies"
@onready var SpinAttackcost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Cost"
@onready var MaxSpincost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Cost"
@onready var SpinDecaycost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Cost"
@onready var CottonCandyStealcost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Cost"
@onready var StrongerEnemiescost: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Cost"

@onready var buttonSpinAttack: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Button"
@onready var buttonMaxSpinPower: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Button"
@onready var buttonSpinDecay: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Button"
@onready var buttonCottonCandySteal: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Button"
@onready var buttonStrongerEnemies: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Button"

var buttonArray: Array[Button] = [buttonSpinAttack, buttonMaxSpinPower, buttonSpinDecay, buttonCottonCandySteal, buttonStrongerEnemies]
var maxLevelArray : Array[int] = [spinAttackMaxLevel, spinBaseMaxLevel, spinDecayMaxLevel, cottonCandyStealMaxLevel, strongerEnemiesMaxLevel]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonSpinAttack.pressed.connect(buySpinAttack)
	buttonMaxSpinPower.pressed.connect(buyMaxSpin)
	buttonSpinDecay.pressed.connect(buySpinDecay)
	buttonCottonCandySteal.pressed.connect(buyCottonCandySteal)
	buttonStrongerEnemies.pressed.connect(buyStrongerEnemies)
	for index: int in buttonArray.size():
		disableButtonsWhenMaxLevel(buttonArray[index], matchIndexToUpgrade(index), maxLevelArray[index])

var spinAttackBaseCost: int = 100
var spinAttackMaxLevel: int = 3
func buySpinAttack() -> void:
	var cost: int
	cost = spinAttackBaseCost * (1 + upgrades.SpinAttack)
	updateCostLabels(SpinAttackcost, cost)
	disableButtonsWhenMaxLevel(buttonSpinAttack, upgrades.SpinAttack, spinAttackMaxLevel)

var maxSpinBaseCost: int = 100
var spinBaseMaxLevel: int = 3
func buyMaxSpin() -> void:
	var cost: int
	cost = maxSpinBaseCost * (1 + upgrades.MaxSpinPower)
	updateCostLabels(MaxSpincost, cost)
	disableButtonsWhenMaxLevel(buttonMaxSpinPower, upgrades.MaxSpinPower, spinBaseMaxLevel)

var spinDecayBaseCost: int = 100
var spinDecayMaxLevel: int = 3
func buySpinDecay() -> void:
	var cost: int
	cost = spinDecayBaseCost * (1 + upgrades.ReduceSpinDecayRate)
	updateCostLabels(SpinDecaycost, cost)
	disableButtonsWhenMaxLevel(buttonSpinDecay, upgrades.ReduceSpinDecayRate, spinDecayMaxLevel)

var cottonCandyStealBaseCost: int = 100
var cottonCandyStealMaxLevel: int = 3
func buyCottonCandySteal() -> void:
	var cost: int
	cost = cottonCandyStealBaseCost * (1 + upgrades.CottonCandyStealPower)
	updateCostLabels(CottonCandyStealcost, cost)
	disableButtonsWhenMaxLevel(buttonCottonCandySteal, upgrades.CottonCandyStealPower, cottonCandyStealMaxLevel)

var strongerEnemiesBaseCost: int = 100
var strongerEnemiesMaxLevel: int = 3
func buyStrongerEnemies() -> void:
	var cost: int
	cost = strongerEnemiesBaseCost * (1 + upgrades.StrongerEnemies)
	updateCostLabels(StrongerEnemiescost, cost)	
	disableButtonsWhenMaxLevel(buttonStrongerEnemies, upgrades.StrongerEnemies, strongerEnemiesMaxLevel)

func disableButton(button:Button) -> void:
	button.disabled = true

func disableButtonsWhenMaxLevel(button: Button, Level: int , maxLevel: int = upgrades.maxLVL) -> void:
	if Level == maxLevel:
		disableButton(button)

func updateCostLabels(label: Label, cost: int) -> void:
	label.text = str(cost)

func matchIndexToUpgrade(index:int) -> int:
	match index:
		0:
			return upgrades.SpinAttack
		1:
			return upgrades.MaxSpinPower
		2:
			return upgrades.ReduceSpinDecayRate
		3:
			return upgrades.CottonCandyStealPower
		4:
			return upgrades.StrongerEnemies
		_:
			return 0

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
