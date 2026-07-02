extends RigidBody2D

class_name BaseSpinner

@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var sfx = get_node("/root/MainGame/FancyCamera/SFX")
@onready var candy_tracker = get_node("/root/MainGame/CanvasLayer/CottonCandyTracker")
@onready var spinner_spawner = get_node("/root/MainGame/Spinners")
@onready var animations = $VerySerious/Animations
@onready var visual_damage = $VerySerious/SpinnerDamaged
@onready var stats:HealthComponent = $HealthComponent
@onready var dash_graphic: Sprite2D = $VerySeriousDash
@onready var collision_circle = $DamageArea

var health_bar: ProgressBar #Assigned in player and enemy subclass

#The various variables that just hold stuff
var hold_decay: int
var candy_multiplier: int
var amplifier: float
var previous_frame: Vector2
var damage_time: float

var mouse_position

var theo_dash_time: float = 7.0
 #State machine stuff
var current_state: STATE = STATE.GLIDING 
#var parry_time: float = 10
enum STATE{
	PARRYING,
	GLIDING,
	DASHING
}

func State_Manager(delta:float):
	#this is a little inneficient since we are just repeatedly assinging the variables to the same thing
	theo_dash_time += delta
	if(theo_dash_time <= stats.ParryStart+stats.ParryDuration && theo_dash_time >= stats.ParryStart):
		if(current_state != STATE.PARRYING):
			current_state = STATE.PARRYING
			self.linear_damp = 0
			dash_graphic.frame = 1
			dash_graphic.visible = true
	elif(theo_dash_time <= stats.DashDuration) :
		
		dash_graphic.frame = 0
		current_state = STATE.DASHING
		self.linear_damp = 0
		dash_graphic.visible = true
	else:
		current_state = STATE.GLIDING
		self.linear_damp = 0.02
		dash_graphic.visible = false

func _process(delta: float) -> void:
	if center_stage.round_playing == true:
		apply_gravity()
		spinforce_manager()
		State_Manager(delta)
		damage_visualizer(delta)

func apply_gravity():
	if(current_state == STATE.GLIDING):
		var to_center = self.position.direction_to(center_stage.position)
		self.apply_force(to_center * center_stage.gravity)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if(current_state != STATE.GLIDING):
		#print("Speed: " + str(state.linear_velocity.length()))
		if(state.linear_velocity.length() <= stats.MinSpeed):
			state.linear_velocity = state.linear_velocity.normalized() *stats.MinSpeed
			#print("speed?!?!?!?!")
			

func spinforce_manager():
	#Handling all the effects that change based on your Speed Force, otherwise known as HP
		if stats.CurrentHP > (stats.MaxHP/2):
			animations.play("PlayerSpinHigh")
			candy_multiplier = stats.CandyMultiplier
			amplifier = stats.PowerAmplifier
		elif stats.CurrentHP > (stats.MaxHP/4):
			animations.play("PlayerSpinMed")
			candy_multiplier = ceili(stats.CandyMultiplier/1.5)
			amplifier = (stats.PowerAmplifier*(stats.SpeedDamageMin + (1 - stats.SpeedDamageMin)/2))
		elif stats.CurrentHP > 0:
			animations.play("PlayerSpinLow")
			candy_multiplier = ceili(stats.CandyMultiplier/2)
			amplifier = (stats.PowerAmplifier*stats.SpeedDamageMin)
		else:
			animations.stop()

func spinner_collision(body: Node2D) -> void:
	#print(body)
	#print("State upon impact: ", current_state)
	#print("THE STATES:\nPARRYING: ", STATE.PARRYING, "\nGliding: ", STATE.GLIDING, "\nDashing: ", STATE.DASHING)
	if current_state != STATE.GLIDING:
		if body.name != self.name and body is RigidBody2D:
			steal_spin(self, body, stats.MaxDamage)

func repulsion(spinner: RigidBody2D):
	#Trying to make sure we bounce away a little bit
	var opposite_direction = -self.position.direction_to(spinner.position)
	self.apply_force(spinner.previous_frame * 0.3 * opposite_direction)

func steal_spin(spinner_one: RigidBody2D, spinner_two: RigidBody2D, damage: int):
	var spinner_one_force = abs(spinner_one.previous_frame.length())
	var spinner_two_force = abs(spinner_two.previous_frame.length())
	repulsion(spinner_two)
	if(spinner_one.current_state == STATE.PARRYING):
		print("We parried 'em!")
		spinner_two.Take_Damage_Interceptor(damage)
		if spinner_two.stats.CurrentHP < 0:
			#Spinners gains an additional health restore for a Takedown
			spinner_one.stats.heal(ceili(damage/2) + ceili(spinner_two.stats.TakedownReward/2))
			#Though, the big reward is saved for your Candy Total, which this code handles
			for scores in candy_tracker.spinners_dictionary:
				if scores == spinner_one.name:
					candy_tracker.spinners_dictionary[scores] += (spinner_two.stats.TakedownReward * 3)
	elif spinner_one_force > spinner_two_force:
		sfx.random_hurt_sound()
		spinner_two.damage_time = 0.5
		print("We got 'em!")
		var force_total = (spinner_one_force + spinner_two_force)
		var force_difference =  (spinner_one_force - spinner_two_force)
		var force_percent = force_difference / force_total
		var spinner_two_damage = ceili(damage * force_percent)
		spinner_two.Take_Damage_Interceptor(spinner_two_damage)
		if spinner_two.stats.CurrentHP < 0:
			#Spinners gains an additional health restore for a Takedown
			spinner_one.stats.heal(ceili(spinner_two_damage/2) + ceili(spinner_two.stats.TakedownReward/2))
			#Though, the big reward is saved for your Candy Total, which this code handles
			for scores in candy_tracker.spinners_dictionary:
				if scores == spinner_one.name:
					candy_tracker.spinners_dictionary[scores] += (spinner_two.stats.TakedownReward * 3)
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

func damage_visualizer(delta):
	if damage_time > 0:
		damage_time -= delta
		visual_damage.visible = true
	else:
		visual_damage.visible = false
