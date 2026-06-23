extends RigidBody2D

@export var temp_world = Node2D
@onready var health = $HealthComponent
var bah = 0
var previous_frame: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var to_center = self.position.direction_to(temp_world.position)
	self.apply_force(to_center * temp_world.gravity)
	bah += 1
	if bah > 60:
		bah = 0
		var random_temp = randi_range(-20, 20)
		var random_temp_two = randi_range(-20, 20)
		self.apply_force(Vector2(random_temp, random_temp_two))
	previous_frame = self.linear_velocity
