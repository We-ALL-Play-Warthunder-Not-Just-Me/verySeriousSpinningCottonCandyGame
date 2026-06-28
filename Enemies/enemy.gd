extends BaseSpinner

@export_category("Enemy Stats")
@export var min_power_meter = 25
@export var max_wait_time = 3.5
@export var min_wait_time = 2.0

var dash_countdown
var final_wait_time
var can_dash = true


func _ready() -> void:
	health_bar = $HealthBar
	final_wait_time = randf_range(min_wait_time, max_wait_time)
	hold_decay = stats.HealthDecay
	collision_circle.body_entered.connect(spinner_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if center_stage.round_playing == true:
		stats.HealthDecay = hold_decay
		health_bar.visible = true
		if can_dash == true:
			final_wait_time -= delta
			if final_wait_time < 0 && current_state == STATE.GLIDING:
				can_dash = false
				dash_countdown = stats.DashDuration
				dash_graphic.visible = true
				pick_target(spinner_spawner.get_children())
		else:
			final_wait_time = randf_range(min_wait_time, max_wait_time)
			dash_countdown -= delta
			if dash_countdown < 0:
				can_dash = true
			elif dash_countdown < stats.DashDuration/3:
				dash_graphic.visible = false
		#spinforce_manager()
		
		#print(self.name, " Candy Multiplier: ", candy_multiplier)
	else:
		self.linear_velocity.lerp(Vector2(0,0),30)
		stats.HealthDecay = 0
		dash_graphic.visible = false
		health_bar.visible = false

	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()

func launch_self(target_position: Vector2):
	var direction_to_target = self.position.direction_to(target_position)
	var final_power = randi_range(min_power_meter, stats.max_power)
	var force = (direction_to_target * final_power).limit_length(stats.max_power)
	theo_dash_time = 0
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
		var chosen_target = spinner_spawner.get_child(random_target)
		if chosen_target.name == self.name:
			#Removing itself from the pool before trying again
			targets.remove_at(random_target)
			pick_target(targets)
		else:
			#print(self.name," has chosen Target: ", chosen_target.name)
			launch_self(chosen_target.position)


func spin_depleted():
	sfx.random_death_sound()
	spinner_spawner.kill_spinner(self)
