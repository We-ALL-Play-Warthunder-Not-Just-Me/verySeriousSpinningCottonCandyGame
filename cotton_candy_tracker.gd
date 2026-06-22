extends Label

var cotton_candy
var candy_value = 1
var final_candy = 0
@onready var player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.


func _on_candy_timer_timeout() -> void:
	var add_candy = candy_value * player.candy_multiplier
	final_candy += add_candy
	#print(final_candy)
	self.text = "Cotton Candy: " + str(final_candy)
