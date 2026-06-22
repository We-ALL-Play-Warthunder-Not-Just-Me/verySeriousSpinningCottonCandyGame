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

@onready var levelSpinAttack: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Level"
@onready var levelMaxSpinPower: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Level"
@onready var levelReduceSpinDecay: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Level"
@onready var levelCottonCandySteal: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Level"
@onready var levelStrongerEnemies: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Level"

@onready var buttonSpinAttack: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Button"
@onready var buttonMaxSpinPower: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Button"
@onready var buttonSpinDecay: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Button"
@onready var buttonCottonCandySteal: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Button"
@onready var buttonStrongerEnemies: Button = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Button"

@onready var cotton_candy_label: Label = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy"

var costLabelArray: Array[Label] = [SpinAttackcost, MaxSpincost, SpinDecaycost, CottonCandyStealcost, StrongerEnemiescost]
var levelLabelArray : Array[Label] = [levelSpinAttack, levelMaxSpinPower, levelReduceSpinDecay, levelCottonCandySteal, levelStrongerEnemies]
var basecostArray: Array[int] = [spinAttackBaseCost, maxSpinBaseCost, spinDecayBaseCost, cottonCandyStealBaseCost, strongerEnemiesBaseCost]
var buttonArray: Array[Button] = [buttonSpinAttack, buttonMaxSpinPower, buttonSpinDecay, buttonCottonCandySteal, buttonStrongerEnemies]
var maxLevelArray : Array[int] = [spinAttackMaxLevel, spinBaseMaxLevel, spinDecayMaxLevel, cottonCandyStealMaxLevel, strongerEnemiesMaxLevel]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonSpinAttack.pressed.connect(buySpinAttack)
	buttonMaxSpinPower.pressed.connect(buyMaxSpin)
	buttonSpinDecay.pressed.connect(buySpinDecay)
	buttonCottonCandySteal.pressed.connect(buyCottonCandySteal)
	buttonStrongerEnemies.pressed.connect(buyStrongerEnemies)
	cottonCandy.cottonCandyChanged.connect(updateCottonCandyAmount)

	updateCottonCandyAmount()
	for index: int in range(5):
		disableButtonsWhenMaxLevel(buttonArray[index], matchIndexToUpgrade(index), maxLevelArray[index])
		var tempcost: int = basecostArray[index] * (1 + matchIndexToUpgrade(index))
		updateCostLabels(costLabelArray[index], tempcost)
		updateLevelLabels(levelLabelArray[index], matchIndexToUpgrade(index))

func updateCottonCandyAmount() -> void:
	cotton_candy_label.text = "Cotton Candy : " + str(cottonCandy.cottonCandyBank)

var spinAttackBaseCost: int = 100
var spinAttackMaxLevel: int = 3
func buySpinAttack() -> void:
	var cost: int
	cost = spinAttackBaseCost * (1 + upgrades.SpinAttack)
	if cottonCandy.cottonCandyBank >= cost:
		upgrades.upgradeStat(upgrades.SpinAttack)
		cottonCandy.removeCottonCandy(cost)
	else:
		print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.SpinAttack)
	updateCostLabels(SpinAttackcost, cost)
	updateLevelLabels(levelSpinAttack, upgrades.SpinAttack)
	disableButtonsWhenMaxLevel(buttonSpinAttack, upgrades.SpinAttack, spinAttackMaxLevel)

var maxSpinBaseCost: int = 100
var spinBaseMaxLevel: int = 3
func buyMaxSpin() -> void:
	var cost: int
	cost = maxSpinBaseCost * (1 + upgrades.MaxSpinPower)
	if cottonCandy.cottonCandyBank >= cost:
		upgrades.upgradeStat(upgrades.MaxSpinPower)
		cottonCandy.removeCottonCandy(cost)
	else:
		print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.MaxSpinPower)
	updateCostLabels(MaxSpincost, cost)
	updateLevelLabels(levelMaxSpinPower, upgrades.MaxSpinPower)
	disableButtonsWhenMaxLevel(buttonMaxSpinPower, upgrades.MaxSpinPower, spinBaseMaxLevel)

var spinDecayBaseCost: int = 100
var spinDecayMaxLevel: int = 3
func buySpinDecay() -> void:
	var cost: int
	cost = spinDecayBaseCost * (1 + upgrades.ReduceSpinDecayRate)
	if cottonCandy.cottonCandyBank >= cost:
		upgrades.upgradeStat(upgrades.ReduceSpinDecayRate)
		cottonCandy.removeCottonCandy(cost)
	else:
		print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.ReduceSpinDecayRate)
	updateCostLabels(SpinDecaycost, cost)
	updateLevelLabels(levelReduceSpinDecay, upgrades.ReduceSpinDecayRate)
	disableButtonsWhenMaxLevel(buttonSpinDecay, upgrades.ReduceSpinDecayRate, spinDecayMaxLevel)

var cottonCandyStealBaseCost: int = 100
var cottonCandyStealMaxLevel: int = 3
func buyCottonCandySteal() -> void:
	var cost: int
	cost = cottonCandyStealBaseCost * (1 + upgrades.CottonCandyStealPower)
	if cottonCandy.cottonCandyBank >= cost:
		upgrades.upgradeStat(upgrades.CottonCandyStealPower)
		cottonCandy.removeCottonCandy(cost)
	else:
		print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.CottonCandyStealPower)
	updateCostLabels(CottonCandyStealcost, cost)
	updateLevelLabels(levelCottonCandySteal, upgrades.CottonCandyStealPower)
	disableButtonsWhenMaxLevel(buttonCottonCandySteal, upgrades.CottonCandyStealPower, cottonCandyStealMaxLevel)

var strongerEnemiesBaseCost: int = 100
var strongerEnemiesMaxLevel: int = 3
func buyStrongerEnemies() -> void:
	var cost: int
	cost = strongerEnemiesBaseCost * (1 + upgrades.StrongerEnemies)
	if cottonCandy.cottonCandyBank >= cost:
		upgrades.upgradeStat(upgrades.StrongerEnemies)
		cottonCandy.removeCottonCandy(cost)
	else:
		print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.StrongerEnemies)
	updateCostLabels(StrongerEnemiescost, cost)	
	updateLevelLabels(levelStrongerEnemies, upgrades.StrongerEnemies)
	disableButtonsWhenMaxLevel(buttonStrongerEnemies, upgrades.StrongerEnemies, strongerEnemiesMaxLevel)

func disableButton(button:Button) -> void:
	if button == null:
		return
	button.disabled = true

func disableButtonsWhenMaxLevel(button: Button, Level: int , maxLevel: int = upgrades.maxLVL) -> void:
	if button == null:
		return
	if Level == maxLevel:
		disableButton(button)

func updateCostLabels(label: Label, cost: int) -> void:
	if label == null:
		return
	label.text = str(cost)

func updateLevelLabels(label: Label, level: int) -> void:
	if label == null:
		return
	label.text = "LVL: " + str(level)

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
