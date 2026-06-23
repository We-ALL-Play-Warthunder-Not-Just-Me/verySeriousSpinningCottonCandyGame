extends RigidBody2D

@export var temp_world = Node2D
var bah = "BAH"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var to_center = self.position.direction_to(temp_world.position)
	self.apply_force(to_center * temp_world.gravity)
