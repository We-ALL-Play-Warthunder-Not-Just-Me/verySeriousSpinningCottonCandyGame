extends RigidBody2D
class_name spinnerBase


#The Upgradable stuff
@export var max_damage = 15
@export var dash_damage = 30
@export var max_amplifier = 3.0
@export var max_candy_multiplier = 3

#Everything else
var max_power = 60
var mouse_position
var amplifier = 0.0
var dash_time = 3
var candy_multiplier
var mouse_on_player = false
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
@onready var spawner = get_node("/root/MainGame/Spawner")
var hold_decay
@onready var sfx = get_node("/root/MainGame/FancyCamera/SFX")






var can_dash = true

@onready var spinners = get_node("..")
#the max distance you can push from 

#THE AMP, this is the number that really makes you go


@export var damage_over_time: int = 5
#The node which will generate gravitational pull
@export var gravity_center: Node2D
#In case we want an object to have multiple gravity sources
@export var gravity_second: Node2D
#Adjusts how strong the gravitational pull is on this spinner
@export var gravity_multiplier: float = 0.0005

var push_direction: Vector2
var dash_ready: bool = true
var iframes: bool = false

@export var dash_ready_timer_max: float = 2
@export var dash_duration_max: float = 1
@export var parry_start: float = 0.5
@export var parry_duration: float = 0.5
@export var iframe_timer_max: float = 0.5
var current_dash_ready_time: float = dash_ready_timer_max +1
var current_iframe_time: float = iframe_timer_max +1
var current_dash_time: float = dash_duration_max+1
@export var armor: float = 1.0

enum State
{
	DASHING,
	DAMAGED,
	GLIDING,
	DEAD,
	STARTING
}

var current_state: State = State.STARTING
#@export var dash_timer: Node2D
#get the health component of the object


@onready var health_timer = $HealthComponent/decayTimer


func _process(delta: float) -> void:
	State_Machine()
	if center_stage.round_playing == true:
		#Apply_Gravity()
		Apply_Timers(delta)
		Dash_Logic(delta)
		
		Update_Previous_Frame()
		
		

func Apply_Timers(delta:float):
	Apply_Dash_Timer(delta)
	Apply_IFrame_Timer(delta)
	Appy_Dash_Duration_Timer(delta)

func Apply_Dash_Timer(delta:float):
	if current_dash_ready_time <= dash_ready_timer_max:
		current_dash_ready_time += delta
	elif(current_dash_ready_time > dash_ready_timer_max):
		dash_ready = true
		
func Appy_Dash_Duration_Timer(delta: float):
	if current_dash_time <= dash_duration_max:
		current_dash_time += delta

func Apply_IFrame_Timer(delta:float):
	if current_iframe_time <= iframe_timer_max:
		current_iframe_time += delta
		
			
func Update_Previous_Frame():
	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()

#This is where you would check if the spinner can and should dash, as well as where it is dashing. Call Dash to know 
func Dash_Logic(delta:float):
	assert(false, "YOU MUST OVVERIDE THE DASH LOGIC IDIOT")
	pass


func Set_State(s:State):
	match s:
		State.DASHING:
			if dash_ready:
				dash_ready = false
				current_dash_ready_time = 0
				current_dash_time = 0
				current_state = State.DASHING
				dash_graphic.visible = true
				return true
			pass
		State.GLIDING:
			current_state = State.GLIDING
			return true
			pass
		State.DAMAGED:
			pass
		State.DEAD:
			pass
		State.STARTING:
			pass
	pass

func State_Machine():
	match current_state:
		State.DASHING:
			Dashing_State()
			pass
		State.GLIDING:
			Gliding_State()
			pass
		State.DAMAGED:
			Damaged_State()
			pass
		State.DEAD:
			Dead_State()
			pass
		State.STARTING:
			Starting_Stat()
			pass

func Dashing_State():
	if(current_dash_time >= dash_duration_max*0.7):
		dash_graphic.visible = false
	if(current_dash_time > dash_duration_max):
		Set_State(State.GLIDING)


func Gliding_State():
	Apply_Gravity()
	

func Damaged_State():
	Apply_Gravity()
	if(current_iframe_time > iframe_timer_max):
		iframes = false;
	
	
func Dead_State():
	
	pass

func Starting_Stat():
	
	pass

func _ready() -> void:
	health_timer.Take_Time_Damage.connect(Time_Damage)

func Dash(force:Vector2) -> void:
	if(Set_State(State.DASHING)):
		self.set_linear_velocity(Vector2(0,0))
		var lim_force = force.limit_length(max_power)
		self.apply_force(lim_force*amplifier)
		
		

func Time_Damage():
	health.takeDamage(damage_over_time)

func Apply_Gravity() -> void:
	# if there is no gravity center we don't do anything
	if(gravity_center != null):
		var to_center: Vector2 = self.position.direction_to(gravity_center.position)
		self.apply_force(to_center * gravity_center.gravity * self.position.distance_squared_to(gravity_center.position)* gravity_multiplier * amplifier)
		#if we have two gravity sources then we apply the second one too
		if(gravity_second != null):
			var to_second: Vector2 = self.position.direction_to(gravity_second.position)
			self.apply_force(to_second * gravity_second.gravity * self.position.distance_squared_to(gravity_second.position)* gravity_multiplier * amplifier)

func Take_Damage(damage:float):
	health.takeDamage(damage*armor)
	
	
func _on_body_entered(body: Node) -> void:
	print("hit something")
	if body.is_in_group("Spinners"):
		print("hit spinner")
		var bigbody = body as spinnerBase
		if(bigbody.Get_My_Force() < Get_My_Force()):
			print("Stealing")
			Steal_Speed(bigbody)

func Steal_Speed(enemy:spinnerBase):
	#inefficient, rework!!!!!!!
	enemy.Take_Damage(max_damage * ceili((Get_My_Force()- enemy.Get_My_Force())/(Get_My_Force()+enemy.Get_My_Force())))
	Heal(max_damage * ceili((Get_My_Force()- enemy.Get_My_Force())/(Get_My_Force()+enemy.Get_My_Force()))/2)

func Heal(healing:float):
	health.heal(healing)
	pass
	




#below are helper functions

func Get_My_Force() ->float:
	var player_force = abs(previous_frame.length())
	return player_force
