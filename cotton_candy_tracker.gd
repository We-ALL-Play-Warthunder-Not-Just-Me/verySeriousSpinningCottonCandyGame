extends Label

@export var candy_value = 4
var spinners_dictionary = {}
@onready var spinners = get_node("/root/MainGame/Spinners")
@onready var spinners_children = spinners.get_children()

func _ready() -> void:
	for child in spinners_children:
		spinners_dictionary.get_or_add(child.name, 0)

func _process(_delta: float) -> void:
	spinners_children = spinners.get_children()

func _on_candy_timer_timeout() -> void:
	add_candy()
	#This is displaying the player's candy in the label on the bottom left. Yes, all of this is in the label on the bottom left. Don't worry.
	self.text = "Cotton Candy: " + str(spinners_dictionary["Player"])

func add_candy():
	#Why is this seperate from the timer timeout? Because I don't know if that'll be permanent, so. We got add_candy just in case.
	for child in spinners_children:
		if spinners_dictionary.has(child.name):
			var add_candy = candy_value * child.candy_multiplier
			spinners_dictionary[child.name] += add_candy
	#print(spinners_dictionary)
