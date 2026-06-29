extends Node2D

@onready var player = get_node("..")
@onready var red_arrow = 0
@onready var yellow_arrow = 1
@onready var green_arrow = 2
@onready var pink_arrow = 3
@onready var head = $Head
@onready var body = $Body
@onready var butt = $Butt

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var draw_arrow_limit = player.position - mouse_position
	
	#Drawing the Arrow head and extending the Body for as long as it needs to be.
	head.position = draw_arrow_limit.limit_length(player.stats.max_power)
	body.scale.x = butt.position.distance_to(head.position)/2
	body.position = (butt.position + (head.position/2))
	
	#You'd think you could jsut rotate the node they're on and not have to do this.
	#You'd think that and be wrong. Gotta rotate each one individually.
	head.rotation = head.position.angle()
	body.rotation = head.position.angle()
	butt.rotation = head.position.angle()
	
	#Changing all the colors according to length
	if draw_arrow_limit.length() > (player.stats.max_power):
		head.frame = pink_arrow
		body.frame = pink_arrow
		butt.frame = pink_arrow
	elif draw_arrow_limit.length() > (player.stats.max_power/2):
		head.frame = green_arrow
		body.frame = green_arrow
		butt.frame = green_arrow
	elif draw_arrow_limit.length() > (player.stats.max_power/4):
		head.frame = yellow_arrow
		body.frame = yellow_arrow
		butt.frame = yellow_arrow
	elif draw_arrow_limit.length() > 0:
		head.frame = red_arrow
		body.frame = red_arrow
		butt.frame = red_arrow
