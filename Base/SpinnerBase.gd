extends RigidBody2D
class_name spinnerBase


#the max distance you can push from 
var power: float = 60
#THE AMP, this is the number that really makes you go
@export var amplifier: float = 0.2

@export var damage_over_time: int = 5
#The node which will generate gravitational pull
@export var gravity_center: Node2D
#In case we want an object to have multiple gravity sources
@export var gravity_second: Node2D
#Adjusts how strong the gravitational pull is on this spinner
@export var gravity_multiplier: float = 1.0
var push_direction: Vector2
var dash_ready: bool = true
var iframes: bool = false
@export var dash_timer_max: float = 2
@export var parry_start: float = 0.5
@export var parry_duration: float = 0.5
@export var iframe_timer_max: float = 0.5
var current_dash_time: float = dash_timer_max +1
var current_iframe_time: float = iframe_timer_max +1
var previouse_frame_velocity: float
@export var armor: float = 1.0
@export var max_damage: float = 30.0
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
@onready var health: HealthComponent = $HealthComponent

@onready var health_timer = $HealthComponent/decayTimer2


func _physics_process(delta: float) -> void:
	Apply_Basics(delta)
	Apply_Gravity()

func Apply_Basics(delta: float):
	if current_dash_time <= dash_timer_max:
		current_dash_time += delta
		if(current_dash_time > dash_timer_max):
			dash_ready = true
		
	if current_iframe_time <= iframe_timer_max:
		current_iframe_time += delta
		if(current_iframe_time > iframe_timer_max):
			iframes = false;
		
	
	previouse_frame_velocity = self.linear_velocity.length()


func State_Machine():
	match current_state:
		State.DASHING:
			pass
		State.GLIDING:
			pass
		State.DAMAGED:
			pass
		State.DEAD:
			pass
		State.STARTING:
			pass

func Dash_State():
	
	pass


func _ready() -> void:
	health_timer.Take_Time_Damage.connect(Time_Damage)

func Dash(force:Vector2) -> void:
	if(dash_ready):
		var lim_force = force.limit_length(power)
		self.apply_force(lim_force*amplifier)
		dash_ready = false
		

func Time_Damage():
	health.takeDamage(damage_over_time)

func Apply_Gravity() -> void:
	if current_state == State.GLIDING:
		var to_center: Vector2 = self.position.direction_to(gravity_center.position)
		self.apply_force(to_center * gravity_center.gravity * self.position.distance_squared_to(gravity_center.position)* amplifier)
		if(gravity_second != null):
			var to_second: Vector2 = self.position.direction_to(gravity_second.position)
			self.apply_force(to_second * gravity_second.gravity * self.position.distance_squared_to(gravity_second.position) * amplifier)

func Take_Damage(damage:float):
	health.takeDamage(damage*armor)
	
func Steal_Speed(enemy:spinnerBase):
	#inefficient, rework!!!!!!!
	print("boop")
	var player_force = abs(previouse_frame_velocity)
	var enemy_force = abs(enemy.previouse_frame_velocity)
	enemy.Take_Damage(max_damage * ceili((player_force- enemy_force)/(player_force+enemy_force)))
	Heal(max_damage * ceili((player_force- enemy_force)/(player_force+enemy_force)))

func Heal(healing:float):
	health.heal(healing)
	pass

func spinner_collision(body: Node) -> void:
	if body.is_in_group("Spinners"):
		var bigbody = body as spinnerBase
		var player_force = abs(previouse_frame_velocity)
		var enemy_force = abs(bigbody.previouse_frame_velocity)
		if(enemy_force < player_force):
			Steal_Speed(bigbody)
			
		
