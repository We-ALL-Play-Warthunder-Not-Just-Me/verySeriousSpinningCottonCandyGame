extends RigidBody2D

@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var spinners = get_node("..")
@onready var health = $HealthComponent
@onready var dash_graphic = $VerySeriousDash
var min_wait_time = 0.5
var max_wait_time = 2.0
var final_wait_time
var previous_frame: Vector2
var max_power = 50
var min_power = 10
var max_amplifier = 1.5
var dash_time = 3
var dash_countdown
var can_dash = true

func _ready() -> void:
	final_wait_time = randf_range(min_wait_time, max_wait_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var to_center = self.position.direction_to(center_stage.position)
	self.apply_force(to_center * center_stage.gravity)

	if can_dash == true:
		final_wait_time -= delta
		if final_wait_time < 0:
			can_dash = false
			dash_countdown = dash_time
			dash_graphic.visible = true
			pick_target()
	else:
		final_wait_time = randf_range(min_wait_time, max_wait_time)
		dash_countdown -= delta
		if dash_countdown < 0:
			can_dash = true
		elif dash_countdown < dash_time/3:
			dash_graphic.visible = false

	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()

func launch_self(target: RigidBody2D):
	var direction_to_target = self.position.direction_to(target.position)
	var final_power = randi_range(min_power, max_power)
	var force = (direction_to_target * final_power).limit_length(max_power)
	self.apply_force(force * max_amplifier)
	print(self.position.direction_to(target.position))
	pass

func pick_target():
	var active_spinners = spinners.get_child_count()
	var random_target = randi_range(0, active_spinners-1)
	var chosen_target = spinners.get_child(random_target)
	if chosen_target.name == self.name:
		pick_target()
	else:
		print(self.name," has chosen Target: ", chosen_target.name)
		launch_self(chosen_target)
