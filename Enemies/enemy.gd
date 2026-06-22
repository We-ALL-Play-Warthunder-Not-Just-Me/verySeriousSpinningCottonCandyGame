extends RigidBody2D

@export var temp_world = Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var to_center = self.position.direction_to(temp_world.position)
	self.apply_force(to_center * temp_world.gravity)
