extends Label

var cotton_candy
var candy_value = 1
var final_candy = 0
@onready var player = get_node("../Player")

func _on_candy_timer_timeout() -> void:
	var add_candy = candy_value * player.candy_multiplier
	final_candy += add_candy
	#print(final_candy)
	self.text = "Cotton Candy: " + str(final_candy)
