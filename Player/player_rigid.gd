extends BaseSpinner

#Everything else
@onready var draw_arrow = $VerySeriousArrows3
@onready var hit_box = $DamageArea/PlayerHitBox
@onready var the_dark = get_node("/root/MainGame/TheDark")
@onready var dash_bar = $CanvasLayer/DashBar

var aiming = false


var mouse_on_player:MOUSESTATE = MOUSESTATE.OFFPLAYER
enum MOUSESTATE{
	ONPLAYER,
	OFFPLAYER
}


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
	if center_stage.round_playing == true:
		stats.HealthDecay = hold_decay
		health_bar.visible = true
		dash_bar.visible = true
		if dash_bar.value > stats.StaminaConsumption && current_state == STATE.GLIDING:
			if Input.is_action_just_pressed("MouseLeftClick") and mouse_on_player == MOUSESTATE.ONPLAYER:
				Engine.set_time_scale(0.2)
				aiming = true
				the_dark.visible = true
			if aiming == true:
				if Input.is_action_pressed("MouseLeftClick"):
					draw_arrow.visible = true
					mouse_position = get_global_mouse_position()
					#print("Hold!")
					#print("Mouse Position: ", mouse_position)
					
				if Input.is_action_just_released("MouseLeftClick"):
					#print("Send!")
					the_dark.visible = false
					dash_bar.takeDamage(stats.StaminaConsumption)
					aiming = false
					self.set_linear_velocity(Vector2(0,0))
					Engine.set_time_scale(1.0)
					draw_arrow.visible = false
					var force = (self.position - mouse_position)
					var lim_force = force.limit_length(stats.max_power)
					theo_dash_time = 0
					self.apply_force(lim_force * amplifier)
					#print(force)
					#print(lim_force)

		#Handling all the effects that change based on your Speed Force, otherwise known as HP
		#spinforce_manager()
	else:
		self.linear_velocity.lerp(Vector2(0,0),30)
		stats.HealthDecay = 0
		dash_graphic.visible = false
		draw_arrow.visible = false
		health_bar.visible = false
		dash_bar.visible = false

	
	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()


func Mouse_Entered():
	mouse_on_player = MOUSESTATE.ONPLAYER

func Mouse_Exited():
	mouse_on_player = MOUSESTATE.OFFPLAYER

func spin_depleted():
	Engine.set_time_scale(1.0)
	the_dark.visible = false
	sfx.random_death_sound()
	spinner_spawner.kill_spinner(self)
