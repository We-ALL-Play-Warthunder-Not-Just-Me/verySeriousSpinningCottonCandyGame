extends Control

#const APPLE_BASE_COST = 30
#const APPLE_QUANTITY_MAX = 5
#@onready var apple_buy_button = $VBoxContainer/HBoxContainer/Button
#@onready var apple_quantity_label = $VBoxContainer/HBoxContainer/Quantity
#@onready var apple_price_label = $VBoxContainer/HBoxContainer/Cost
#var apple_quantity = 0

#Bank
@onready var money_label = $Label
var stored_money = 4000

#Dictionaries
@onready var apple_dict = {"Base Cost": 30, "Quantity": 0, "Max Quantity": 5,
"Quantity Label": $VBoxContainer/HBoxContainer/Quantity,
"Price Label": $VBoxContainer/HBoxContainer/Cost,
"Buy Button": $VBoxContainer/HBoxContainer/Button}

@onready var lemon_dict = {"Base Cost": 20, "Quantity": 0, "Max Quantity": 8,
"Quantity Label": $VBoxContainer/HBoxContainer2/Quantity,
"Price Label": $VBoxContainer/HBoxContainer2/Cost,
"Buy Button": $VBoxContainer/HBoxContainer2/Button}

@onready var pear_dict = {"Base Cost": 15, "Quantity": 0, "Max Quantity": 12,
"Quantity Label": $VBoxContainer/HBoxContainer3/Quantity,
"Price Label": $VBoxContainer/HBoxContainer3/Cost,
"Buy Button": $VBoxContainer/HBoxContainer3/Button}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apple_dict["Buy Button"].pressed.connect(buyFruit.bind(apple_dict))
	lemon_dict["Buy Button"].pressed.connect(buyFruit.bind(lemon_dict))
	pear_dict["Buy Button"].pressed.connect(buyFruit.bind(pear_dict))

func buyFruit(dict: Dictionary) -> void:
	#print("Old: ", dict)
	var cost: int = dict["Base Cost"] * (1 + dict["Quantity"])
	if stored_money >= cost:
		dict["Quantity"] += 1
		stored_money -= cost
		money_label.text = "Money: " + str(stored_money)
	else:
		print("Too Expensive")
	cost = dict["Base Cost"] * (1 + dict["Quantity"])
	dict["Price Label"].text = "Cost: " + str(cost)
	dict["Quantity Label"].text = "Quantity: " + str(dict["Quantity"])
	if (dict["Quantity"] >= dict["Max Quantity"]):
		dict["Buy Button"].disabled = true
		dict["Buy Button"].text = "MAX"
	#print("New: ", dict)
	#print("Original: ", apple_dict)

#func buyApple() -> void:
	#var cost: int = APPLE_BASE_COST * (1 + apple_quantity)
	#if stored_money >= cost:
		#apple_quantity += 1
		#stored_money -= cost
		#money_label.text = "Money: " + str(stored_money)
	#else:
		#print("Too Expensive")
	#cost = APPLE_BASE_COST * (1 + apple_quantity)
	#apple_price_label.text = "Cost: " + str(cost)
	#apple_quantity_label.text = "Quantity: " + str(apple_quantity)
	#if (apple_quantity >= APPLE_QUANTITY_MAX):
		#apple_buy_button.disabled = true
		#apple_buy_button.text = "MAX"
