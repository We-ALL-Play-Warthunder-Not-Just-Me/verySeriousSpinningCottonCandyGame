extends RigidBody2D

#The Upgradable stuff
@export var max_damage = 15
@export var dash_depletion = 30
@export var max_amplifier = 3.0
@export var max_candy_multiplier = 3
@export var parry_duration:float = 0.5
@export var parry_start:float = 0.3
@export var takedown_reward = 30


#Everything else
var max_power = 60
var mouse_position
var amplifier = 0.0
var dash_time = 3
var candy_multiplier

@onready var draw_arrow = $VerySeriousArrows3
@onready var health = $HealthComponent
@onready var animations = $VerySeriousPlayer/PlayerAnimations
@onready var hit_box = $DamageArea/PlayerHitBox
@onready var dash_graphic = $VerySeriousDash
@onready var the_dark = get_node("/root/MainGame/TheDark")
@onready var dash_bar = $CanvasLayer/DashBar
@onready var health_bar = $CanvasLayer/HealthBar
var aiming = false
var dash_countdown
@onready var center_stage = get_node("/root/MainGame/CenterStage")
var previous_frame: Vector2
@onready var spawner = get_node("/root/MainGame/Spinners")
var hold_decay
@onready var sfx = get_node("/root/MainGame/FancyCamera/SFX")
@onready var attack = load("res://steal_spin_attack.gd").new()

var mouse_on_player:MOUSESTATE = MOUSESTATE.OFFPLAYER
enum MOUSESTATE{
	ONPLAYER,
	OFFPLAYER
}

#parry state works off the players 
var parry_state: PARRYSTATE = PARRYSTATE.NOTPARRYING 
var parry_time: float = 10
enum PARRYSTATE{
	PARRYING,
	NOTPARRYING
}

func _ready() -> void:
	#Initializing Players Stats
	hold_decay = health.HealthDecay
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if center_stage.round_playing == true:
		health.HealthDecay = hold_decay
		health_bar.visible = true
		dash_bar.visible = true
		if dash_bar.value > dash_damage:
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
					dash_bar.takeDamage(dash_depletion)
					aiming = false
					dash_countdown = dash_time
					dash_graphic.visible = true
					self.set_linear_velocity(Vector2(0,0))
					Engine.set_time_scale(1.0)
					draw_arrow.visible = false
					var force = (self.position - mouse_position)
					var lim_force = force.limit_length(max_power)
					self.apply_force(lim_force * amplifier)
					#print(force)
					#print(lim_force)
		else:
			dash_countdown -= delta
			if dash_countdown < dash_time/3:
				dash_graphic.visible = false

		if health.CurrentHP > (health.MaxHp/2):
			animations.play("PlayerSpinHigh")
			candy_multiplier = 3
			amplifier = max_amplifier
		elif health.CurrentHP > (health.MaxHp/4):
			animations.play("PlayerSpinMed")
			candy_multiplier = 2
			if (max_amplifier/1.5) < 1:
				amplifier = 1
			else:
				amplifier = (max_amplifier/1.5)
		elif health.CurrentHP > 0:
			animations.play("PlayerSpinLow")
			candy_multiplier = 1
			if (max_amplifier/2) < 1:
				amplifier = 1
			else:
				amplifier = (max_amplifier/2)
		else:
			animations.stop()
	else:
		self.linear_velocity.lerp(Vector2(0,0),30)
		health.HealthDecay = 0
		dash_graphic.visible = false
		draw_arrow.visible = false
		health_bar.visible = false
		dash_bar.visible = false

	var to_center = self.position.direction_to(center_stage.position)
	self.apply_force(to_center * center_stage.gravity)
	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()


func Mouse_Entered():
	mouse_on_player = MOUSESTATE.ONPLAYER

func Mouse_Exited():
	mouse_on_player = MOUSESTATE.OFFPLAYER

func Parry_Manager(delta:float):
	parry_time += delta
	if(parry_time <= parry_start+parry_duration && parry_time >= parry_start):
		parry_state = PARRYSTATE.PARRYING
	else:
		parry_state = PARRYSTATE.NOTPARRYING

func _on_damage_area_entered(body: Node2D) -> void:
	if body.name != self.name and body is RigidBody2D:
		sfx.random_hurt_sound()
		attack.steal_spin(self, body, max_damage)

func spin_depleted():
	Engine.set_time_scale(1.0)
	the_dark.visible = false
	sfx.random_death_sound()
	spawner.kill_spinner(self)
