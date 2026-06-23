extends RigidBody2D

var mouse_position
var amplifier = 0.0
var max_power = 60
var dash_time = 5
var candy_multiplier
var max_damage = 30
@onready var draw_arrow = $VerySeriousArrows3
@onready var health = $HealthComponent
@onready var animations = $VerySeriousPlayer/PlayerAnimations
@onready var hit_box = $DamageArea/PlayerHitBox
@onready var half_health = health.MaxHp/2
@onready var fourth_health = health.MaxHp/4
@onready var half_power = max_power/2
@onready var fourth_power = max_power/4
var can_dash = true
var aiming = false
var dash_countdown
@export var center_stage = Node2D
var previous_frame: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_dash == true:
		if Input.is_action_just_pressed("MouseLeftClick"):
			Engine.set_time_scale(0.1)
			aiming = true
		if aiming == true:
			if Input.is_action_pressed("MouseLeftClick"):
				draw_arrow.visible = true
				mouse_position = get_global_mouse_position()
				#print("Hold!")
				#print("Mouse Position: ", mouse_position)
				
			if Input.is_action_just_released("MouseLeftClick"):
				#print("Send!")
				can_dash = false
				aiming = false
				dash_countdown = dash_time
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
		#print(int(ceili(dash_countdown)))
		if dash_countdown <= 0:
			can_dash = true
	
	if health.CurrentHP > half_health:
		animations.play("PlayerSpinHigh")
		candy_multiplier = 3
		amplifier = 3.0
	elif health.CurrentHP > fourth_health:
		animations.play("PlayerSpinMed")
		candy_multiplier = 2
		amplifier = 2.0
	elif health.CurrentHP > 0:
		animations.play("PlayerSpinLow")
		candy_multiplier = 1
		amplifier = 1.0
	else:
		animations.stop()
		candy_multiplier = 0

	var to_center = self.position.direction_to(center_stage.position)
	self.apply_force(to_center * center_stage.gravity)
	previous_frame = self.linear_velocity

func steal_spin(enemy: RigidBody2D):
	var player_force = abs(previous_frame.length())
	var enemy_force = abs(enemy.previous_frame.length())
	if player_force > enemy_force:
		print("We got 'em!")
		var force_total = (player_force + enemy_force)
		var force_difference =  (player_force - enemy_force)
		var force_percent = force_difference / force_total
		var enemy_damage = ceili(max_damage * force_percent)
		enemy.health.takeDamage(enemy_damage)
		self.health.heal(enemy_damage/2)
		#print("Player Force: ", player_force)
		#print("Enemy Force: ", enemy_force)
		#print("Total Force: ", force_total)
		#print("The Difference: ", force_difference)
		#print("Force Percentage: ", force_percent)
		#print("Enemy Current HP: ", enemy.health.CurrentHP)
		#print("Enemy HP to lose: ", enemy_damage)
	elif player_force < enemy_force:
		print("We're not strong enough...")

func _on_damage_area_entered(body: Node2D) -> void:
	print("boop")
	if body.name != "Player" and body is RigidBody2D:
		steal_spin(body)
		#var hold = self.linear_velocity.normalized() * (test.shape.radius * 2)
		#test_arrow_two.target_position = previous_frame
		#Engine.set_time_scale(0.0)
	
