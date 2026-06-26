extends RigidBody2D

class_name BaseSpinner



#@onready var attack = load("res://steal_spin_attack.gd").new()
@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var sfx = get_node("/root/MainGame/FancyCamera/SFX")
@onready var animations = $VerySerious/Animations
@onready var stats:HealthComponent = $HealthComponent
@onready var dash_graphic = $VerySeriousDash


var health_bar: ProgressBar #Assigned in player and enemy subclass
var max_power = 60
var mouse_position
var amplifier = 0.0
var dash_time = 3.0
var candy_multiplier
var theo_dash_time: float = 3.0
 #State machine stuff
var current_state: STATE = STATE.GLIDING 
#var parry_time: float = 10
enum STATE{
	PARRYING,
	GLIDING,
	DASHING
}

func State_Manager(delta:float):
	theo_dash_time += delta
	if(theo_dash_time <= stats.ParryStart+stats.ParryDuration && theo_dash_time >= stats.ParryStart):
		current_state = STATE.PARRYING
	elif(theo_dash_time <= stats.DashDuration) :
		current_state = STATE.DASHING
	else:
		current_state = STATE.GLIDING

func _process(delta: float) -> void:
	if center_stage.round_playing == true:
		apply_gravity()
		spinforce_manager()

func apply_gravity():
	if(current_state == STATE.GLIDING):
		var to_center = self.position.direction_to(center_stage.position)
		self.apply_force(to_center * center_stage.gravity)

func spinforce_manager():
	#Handling all the effects that change based on your Speed Force, otherwise known as HP
		if stats.CurrentHP > (stats.MaxHP/2):
			animations.play("PlayerSpinHigh")
			candy_multiplier = stats.CandyMultiplier
			amplifier = stats.PowerAmplifier
		elif stats.CurrentHP > (stats.MaxHP/4):
			animations.play("PlayerSpinMed")
			candy_multiplier = (stats.CandyMultiplier/1.5)
			if (stats.PowerAmplifier/1.5) < 1:
				amplifier = 1
			else:
				amplifier = (stats.PowerAmplifier/1.5)
		elif stats.CurrentHP > 0:
			animations.play("PlayerSpinLow")
			candy_multiplier = (stats.CandyMultiplier/2)
			if (stats.PowerAmplifier/2) < 1:
				amplifier = 1
			else:
				amplifier = (stats.PowerAmplifier/2)
		else:
			animations.stop()

func _on_damage_area_entered(body: Node2D) -> void:
	if current_state != STATE.GLIDING:
		if body.name != self.name and body is RigidBody2D:
			sfx.random_hurt_sound()
			steal_spin(self, body, stats.MaxDamage)

func steal_spin(spinner_one: RigidBody2D, spinner_two: RigidBody2D, damage: int):
	var spinner_one_force = abs(spinner_one.previous_frame.length())
	var spinner_two_force = abs(spinner_two.previous_frame.length())
	if spinner_one_force > spinner_two_force:
		print("We got 'em!")
		var force_total = (spinner_one_force + spinner_two_force)
		var force_difference =  (spinner_one_force - spinner_two_force)
		var force_percent = force_difference / force_total
		var spinner_two_damage = ceili(damage * force_percent)
		spinner_two.Take_Damage_Interceptor(spinner_two_damage)
		if spinner_two.stats.CurrentHP < 0:
			spinner_one.stats.heal(ceili(spinner_two_damage/2) + stats.TakedownReward)
		else:
			spinner_one.stats.heal(ceili(spinner_two_damage/2))
		#print("Spinner Force: ", spinner_one_force)
		#print("Opponent Force: ", spinner_two_force)
		#print("Total Force: ", force_total)
		#print("The Difference: ", force_difference)
		#print("Force Percentage: ", force_percent)
		#print("Opponent Current HP: ", spinner_two.stats.CurrentHP)
		#print("Opponent HP to lose: ", spinner_two_damage)
	elif spinner_one_force < spinner_two_force:
		print("We're not strong enough...")
func Take_Damage_Interceptor(damage:int):
	if current_state != STATE.PARRYING:
		stats.takeDamage(damage)		
	
