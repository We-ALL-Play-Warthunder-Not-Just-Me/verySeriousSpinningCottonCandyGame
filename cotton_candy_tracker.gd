extends Label

var cotton_candy
var candy_value = 1
var final_candy = 0
var candy_multiplier = 0
var spinners_dictionary = {}
@onready var spinners = get_node("../Spinners")
@onready var spinners_children = spinners.get_children()
#@onready var player = get_node("../Player")

func create_dictionary_of_spinners():
	for child in spinners_children:
		var tag = child.name
		spinners_dictionary.get_or_add(tag, 0)

func _ready() -> void:
	create_dictionary_of_spinners()

func _process(delta: float) -> void:
	spinners_children = spinners.get_children()

func _on_candy_timer_timeout() -> void:
	add_candy()

func add_candy():
	for child in spinners_children:
		if spinners_dictionary.has(child.name):
			var add_candy = candy_value * child.candy_multiplier
			spinners_dictionary[child.name] += add_candy
	print(spinners_dictionary)
	#print(final_candy)
	#self.text = "Cotton Candy: " + str(final_candy)

func player_died():
	candy_multiplier = 0
