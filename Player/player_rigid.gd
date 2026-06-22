extends RigidBody2D

var mouse_position
var amplifier = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("MouseLeftClick"):
		mouse_position = get_global_mouse_position()
		print("Hold!")
		print("Mouse Position: ", mouse_position)
		var distance = self.position.distance_to(mouse_position)
		print("Distance From Player: ", distance)
	
	if Input.is_action_just_released("MouseLeftClick"):
		print("Send!")
		var x_force = (self.position.x - mouse_position.x) * amplifier
		var y_force = (self.position.y - mouse_position.y) * amplifier
		var total_force = Vector2(x_force, y_force)
		self.apply_force(total_force)
