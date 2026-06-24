extends RigidBody2D

@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var spawner = get_node("/root/MainGame/Spawner")
@onready var spinners = get_node("..")
@onready var health = $HealthComponent
@onready var dash_graphic = $VerySeriousDash
@onready var animations = $VerySeriousEnemy/EnemyAnimations
var min_wait_time = 0.5
var max_wait_time = 2.0
var final_wait_time
var previous_frame: Vector2
var max_power = 50
var min_power = 10
var max_amplifier = 1.5
var amplifier
var dash_time = 3
var dash_countdown
var can_dash = true
var candy_multiplier

func _ready() -> void:
	final_wait_time = randf_range(min_wait_time, max_wait_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var to_center = self.position.direction_to(center_stage.position)
	self.apply_force(to_center * center_stage.gravity)
	
	if center_stage.round_playing == true:
		if can_dash == true:
			final_wait_time -= delta
			if final_wait_time < 0:
				can_dash = false
				dash_countdown = dash_time
				dash_graphic.visible = true
				pick_target(spinners.get_children())
		else:
			final_wait_time = randf_range(min_wait_time, max_wait_time)
			dash_countdown -= delta
			if dash_countdown < 0:
				can_dash = true
			elif dash_countdown < dash_time/3:
				dash_graphic.visible = false
		
		if health.CurrentHP > (health.MaxHp/2):
			animations.play("PlayerSpinHigh")
			candy_multiplier = 3
			amplifier = max_amplifier
		elif health.CurrentHP > (health.MaxHp/4):
			animations.play("PlayerSpinMed")
			candy_multiplier = 2
			amplifier = (max_amplifier/2)
		elif health.CurrentHP > 0:
			animations.play("PlayerSpinLow")
			candy_multiplier = 1
			amplifier = (max_amplifier/4)
		else:
			animations.stop()
	else:
		self.linear_velocity.lerp(Vector2(0,0),30)
		health.HealthDecay = 0

	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()

func launch_self(target_position: Vector2):
	var direction_to_target = self.position.direction_to(target_position)
	var final_power = randi_range(min_power, max_power)
	var force = (direction_to_target * final_power).limit_length(max_power)
	self.apply_force(force * amplifier)

func pick_target(targets: Array):
	var active_spinners = targets.size()
	if active_spinners == 0:
		#If no one else is around, go in a random direction
		var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)) + self.position
		launch_self(random_direction)
	else:
		#Picking randomly who to go for in the array of options
		var random_target = randi_range(0, active_spinners-1)
		var chosen_target = spinners.get_child(random_target)
		if chosen_target.name == self.name:
			#Removing itself from the pool before trying again
			targets.remove_at(random_target)
			pick_target(targets)
		else:
			#print(self.name," has chosen Target: ", chosen_target.name)
			launch_self(chosen_target.position)

func spin_depleted():
	spawner.kill_spinner(self)
