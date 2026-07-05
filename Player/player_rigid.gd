extends BaseSpinner

#Everything else
@onready var hit_box = $DamageArea/PlayerHitBox
@onready var the_dark = get_node("/root/MainGame/TheDark")
@onready var dash_bar = $CanvasLayer/DashBar

@export var using_mouse: bool
@export var using_controller: bool
@export var using_keyboard: bool

var arrow_direction: Vector2
var aimer_position: Vector2
var aiming: bool = false


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
	#Seting up the assets to start the round
	if center_stage.round_playing == true:
		print(name,"'s Health Decay ",stats.HealthDecay)
		#Temp Stop
		if Input.is_action_just_pressed("TempDebug"): self.linear_velocity = Vector2(0, 0)
		
		#Controls...
		mouse_controls(using_mouse)
		controller_controls(using_controller)
		keyboard_controls(using_keyboard)

	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()
	dash_bar.visible = health_bar.visible

func mouse_controls(using: bool):
	if using:
		print("Mouse Player")
		#Dash Mouse Inputs
		if dash_bar.value > stats.StaminaConsumption:
			if Input.is_action_just_pressed("Dash (Mouse)") and mouse_on_player == MOUSESTATE.ONPLAYER:
				start_dash()
			
			if Input.is_action_pressed("Dash (Mouse)") and aiming:
				aimer_position = get_local_mouse_position()
				arrow_direction = -aimer_position
				#print(aimer_position)
			
			if Input.is_action_just_released("Dash (Mouse)") and aiming:
				end_dash(-aimer_position)

func controller_controls(using: bool):
	if using:
		print("Controller Player")
		#Dash Controller Inputs
		if dash_bar.value > stats.StaminaConsumption:
			if Input.is_action_just_pressed("Dash (Controller)"):
				start_dash()
			
			if Input.is_action_pressed("Dash (Controller)") and aiming:
				var x_axis = Input.get_axis("Left (Controller)", "Right (Controller)")*stats.max_power
				var y_axis = Input.get_axis("Up (Controller)", "Down (Controller)")*stats.max_power
				aimer_position = Vector2(x_axis, y_axis)
				arrow_direction = aimer_position
			
			if Input.is_action_just_released("Dash (Controller)") and aiming:
				#print("Send!")
				end_dash(aimer_position)


func keyboard_controls(using: bool):
	if using:
		print("Keyboard Player")
		#Dash Keyboard Inputs
		if dash_bar.value > stats.StaminaConsumption:
			if Input.is_action_just_pressed("Dash (Keyboard)"):
				start_dash()
			
			if Input.is_action_pressed("Dash (Keyboard)") and aiming:
				var x_axis = Input.get_axis("Left (Keyboard)", "Right (Keyboard)")*stats.max_power
				var y_axis = Input.get_axis("Up (Keyboard)", "Down (Keyboard)")*stats.max_power
				aimer_position = Vector2(x_axis, y_axis)
				arrow_direction = aimer_position
			
			if Input.is_action_just_released("Dash (Keyboard)") and aiming:
				end_dash(aimer_position)

#The Dash Functions
func  start_dash():
	print("Aiming...")
	Engine.set_time_scale(0.2)
	the_dark.visible = true
	aiming = true

#Sets the player loose to dash
func end_dash(force: Vector2):
	print("FIRE!")
	the_dark.visible = false
	aiming = false
	dash_bar.takeDamage(stats.StaminaConsumption)
	self.set_linear_velocity(Vector2(0,0))
	Engine.set_time_scale(1.0)
	dash_self(force)

func Mouse_Entered():
	mouse_on_player = MOUSESTATE.ONPLAYER

func Mouse_Exited():
	mouse_on_player = MOUSESTATE.OFFPLAYER

func spin_depleted():
	Engine.set_time_scale(1.0)
	the_dark.visible = false
	aiming = false
	sfx.random_death_sound()
	spinner_spawner.kill_spinner(self)
