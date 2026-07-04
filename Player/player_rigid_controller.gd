extends BaseSpinner

#Everything else
@onready var hit_box = $DamageArea/PlayerHitBox
@onready var the_dark = get_node("/root/MainGame/TheDark")
@onready var dash_bar = $CanvasLayer/DashBar

var aimer_position
var aiming: bool = false

func _ready() -> void:
	hold_decay = stats.HealthDecay
	health_bar = $CanvasLayer/HealthBar
	print("Player Stats!")
	print("Max HP: ", stats.MaxHP)
	print("Current HP: ", stats.CurrentHP)
	print("Health Decay: ", stats.HealthDecay)
	print("Max Damage: ", stats.MaxDamage)
	print("Dash Consumption: ", stats.StaminaConsumption)
	print("Power Amplifier: ", stats.PowerAmplifier)
	print("Candy Multiplier: ", stats.CandyMultiplier)
	collision_circle.body_entered.connect(spinner_collision)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	#Seting up the assets to start the round
	if center_stage.round_playing == true:
		stats.HealthDecay = hold_decay
		health_bar.visible = true
		dash_bar.visible = true
		
		#The Dash Function
		if dash_bar.value > stats.StaminaConsumption:
			if Input.is_action_just_pressed("Dash"):
				Engine.set_time_scale(0.2)
				the_dark.visible = true
				aiming = true

			aimer_position = get_global_mouse_position()
			#Sets the player loose to dash
			if Input.is_action_just_released("Dash") and aiming:
				#print("Send!")
				the_dark.visible = false
				aiming = false
				dash_bar.takeDamage(stats.StaminaConsumption)
				self.set_linear_velocity(Vector2(0,0))
				Engine.set_time_scale(1.0)
				var force = (self.position - aimer_position)
				dash_self(force)
				#print(force)
				#print(lim_force)

	else:
		self.current_state = STATE.GLIDING
		self.linear_velocity.lerp(Vector2(0,0),30)
		stats.HealthDecay = 0
		dash_graphic.visible = false
		health_bar.visible = false
		dash_bar.visible = false

	
	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()


func Mouse_Entered():
	pass

func Mouse_Exited():
	pass

func spin_depleted():
	Engine.set_time_scale(1.0)
	the_dark.visible = false
	sfx.random_death_sound()
	spinner_spawner.kill_spinner(self)
