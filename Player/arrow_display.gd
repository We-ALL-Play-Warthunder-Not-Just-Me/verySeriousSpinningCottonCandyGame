extends Sprite2D

@onready var player = get_node("..")
@onready var red_arrow = load("res://Assets/Images/Very Serious Arrows1.png")
@onready var yellow_arrow = load("res://Assets/Images/Very Serious Arrows2.png")
@onready var green_arrow = load("res://Assets/Images/Very Serious Arrows3.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var draw_arrow_limit = player.position - mouse_position
	self.position = draw_arrow_limit.limit_length(player.stats.max_power)
	self.rotation = self.position.angle()
	if draw_arrow_limit.length() > (player.stats.max_power/2):
		self.texture = green_arrow
	elif draw_arrow_limit.length() > (player.stats.max_power/4):
		self.texture = yellow_arrow
	elif draw_arrow_limit.length() > 0:
		self.texture = red_arrow
