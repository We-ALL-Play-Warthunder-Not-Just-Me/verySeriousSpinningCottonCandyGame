extends RigidBody2D

var mouse_position
var amplifier = 100
@onready var arrow_test = $VerySeriousArrows3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("MouseLeftClick"):
		arrow_test.visible = true
		mouse_position = get_global_mouse_position()
		print("Hold!")
		print("Mouse Position: ", mouse_position)
		var test_position_x
		var test_position_y
		test_position_x = self.position.x - mouse_position.x
		test_position_y = self.position.y - mouse_position.y
		arrow_test.position = Vector2(test_position_x, test_position_y).limit_length(60)
		arrow_test.rotation = arrow_test.position.angle()
		
	
	if Input.is_action_just_released("MouseLeftClick"):
		print("Send!")
		arrow_test.visible = false
		var x_force = (self.position.x - mouse_position.x) * amplifier
		var y_force = (self.position.y - mouse_position.y) * amplifier
		var total_force = Vector2(x_force, y_force)
		self.apply_force(total_force)
