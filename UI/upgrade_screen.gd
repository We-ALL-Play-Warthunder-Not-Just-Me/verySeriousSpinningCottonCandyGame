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

@onready var buttonSpinAttack: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Spin Attack/Button"
@onready var buttonMaxSpinPower: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Max Spin Power/Button"
@onready var buttonSpinDecay: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Reduce Spin Decay/Button"
@onready var buttonCottonCandySteal: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Cotton Candy Steal/Button"
@onready var buttonStrongerEnemies: TextureButton = $"backgroundthing/PanelContainer/MarginContainer/VBoxContainer/Stronger Enemies/Button"

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
@export var strongerEnemiesBaseCost: int = 100
@export var strongerEnemiesMaxLevel: int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonSpinAttack.pressed.connect(buyUpgrade.bind(0))
	buttonMaxSpinPower.pressed.connect(buyUpgrade.bind(1))
	buttonSpinDecay.pressed.connect(buyUpgrade.bind(2))
	buttonCottonCandySteal.pressed.connect(buyUpgrade.bind(3))
	buttonStrongerEnemies.pressed.connect(buyUpgrade.bind(4))

	continue_button.pressed.connect(continueGame)

	cottonCandy.cottonCandyChanged.connect(updateCottonCandyAmount)
	cotton_candy_label.text = "Cotton Candy : " + str(cottonCandy.cottonCandyBank)
	evilInitialize()

func continueGame() -> void:
	pass

func evilInitialize() -> void:
	buySpinAttack(true)
	buyMaxSpin(true)
	buySpinDecay(true)
	buyCottonCandySteal(true)
	buyStrongerEnemies(true)

func updateCottonCandyAmount(newamount: int, oldamount: int) -> void:
	print("old candy amount : " + str(oldamount))
	cotton_candy_label.text = "Cotton Candy : " + str(newamount)

func buyUpgrade(index: int) -> void:
	match index:
		0:
			buySpinAttack()
		1:
			buyMaxSpin()
		2:
			buySpinDecay()
		3:
			buyCottonCandySteal()
		4:
			buyStrongerEnemies()
		_:
			return

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

func buySpinAttack(init:bool = false) -> void:
	var cost: int
	cost = spinAttackBaseCost * (1 + upgrades.SpinAttack)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.upgradeStat(upgrades.SpinAttack)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.SpinAttack)
	SpinAttackcost.text = str(cost)
	levelSpinAttack.text = "LVL : " + str(upgrades.SpinAttack)
	if (upgrades.SpinAttack >= spinAttackMaxLevel):
		buttonSpinAttack.disabled = true

func buyMaxSpin(init:bool = false) -> void:
	var cost: int
	cost = maxSpinBaseCost * (1 + upgrades.MaxSpinPower)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.upgradeStat(upgrades.MaxSpinPower)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.MaxSpinPower)
	MaxSpincost.text = str(cost)
	levelMaxSpinPower.text = "LVL : " +  str(upgrades.MaxSpinPower)
	if (upgrades.MaxSpinPower >= maxspinMaxLevel):
		buttonMaxSpinPower.disabled = true


func buySpinDecay(init:bool = false) -> void:
	var cost: int
	cost = spinDecayBaseCost * (1 + upgrades.ReduceSpinDecayRate)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.upgradeStat(upgrades.ReduceSpinDecayRate)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.ReduceSpinDecayRate)
	SpinDecaycost.text = str(cost)
	levelReduceSpinDecay.text = "LVL : " + str(upgrades.ReduceSpinDecayRate)
	if (upgrades.ReduceSpinDecayRate >= spinDecayMaxLevel):
		buttonSpinDecay.disabled = true


func buyCottonCandySteal(init:bool = false) -> void:
	var cost: int
	cost = cottonCandyStealBaseCost * (1 + upgrades.CottonCandyStealPower)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.upgradeStat(upgrades.CottonCandyStealPower)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.CottonCandyStealPower)
	CottonCandyStealcost.text = str(cost)
	levelCottonCandySteal.text = "LVL : " + str(upgrades.CottonCandyStealPower)
	if (upgrades.CottonCandyStealPower >= cottonCandyStealMaxLevel):
		buttonCottonCandySteal.disabled = true


func buyStrongerEnemies(init:bool = false) -> void:
	var cost: int
	cost = strongerEnemiesBaseCost * (1 + upgrades.StrongerEnemies)
	if (!init):
		if cottonCandy.cottonCandyBank >= cost:
			upgrades.upgradeStat(upgrades.StrongerEnemies)
			cottonCandy.removeCottonCandy(cost)
		else:
			print("Too Expensive")
	cost = spinAttackBaseCost * (1 + upgrades.StrongerEnemies)
	StrongerEnemiescost.text = str(cost)	
	levelStrongerEnemies.text = "LVL : " + str(upgrades.StrongerEnemies)
	if (upgrades.StrongerEnemies >= strongerEnemiesMaxLevel):
		buttonStrongerEnemies.disabled = true



# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
