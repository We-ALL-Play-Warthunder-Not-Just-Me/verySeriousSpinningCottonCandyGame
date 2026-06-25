extends spinnerBase





@onready var animations = $VerySeriousBase/BaseAnimations
var min_wait_time = 0.5

var final_wait_time: float = 0
var wait_time: float = dash_ready_timer_max+1
var min_power = 10





func _ready() -> void:
	final_wait_time = randf_range(min_wait_time, dash_ready_timer_max)

func Apply_Timers(delta:float):
	super(delta)
	Apply_Dash_Waiting_Timer(delta)

func Apply_Dash_Waiting_Timer(delta: float):
	if wait_time <= final_wait_time:
		wait_time +=delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	
	if center_stage.round_playing == true:
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


func Dash_Logic(delta:float):
	if center_stage.round_playing == true:
		if dash_ready == true:
			if wait_time > final_wait_time:
				pick_target(spinners.get_children())
				final_wait_time = dash_duration_max+randf_range(min_wait_time, dash_ready_timer_max)
				wait_time = 0
	pass

#func launch_self(target_position: Vector2):
	#var direction_to_target = self.position.direction_to(target_position)
	#var final_power = randi_range(min_power, max_power)
	#var force = (direction_to_target * final_power).limit_length(max_power)
	#self.apply_force(force * amplifier)

func pick_target(targets: Array):
	var active_spinners = targets.size()
	if active_spinners == 0:
		#If no one else is around, go in a random direction
		var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)) + self.position
		Dash(random_direction)
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
			Dash(chosen_target.position)





func spin_depleted():
	spawner.kill_spinner(self)
