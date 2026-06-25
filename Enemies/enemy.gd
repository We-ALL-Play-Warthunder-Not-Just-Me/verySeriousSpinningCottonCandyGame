extends RigidBody2D

@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var spawner = get_node("/root/MainGame/Spawner")
@onready var spinners = get_node("..")
@onready var health_bar = $HealthBar
@onready var health = $HealthComponent
@onready var dash_graphic = $VerySeriousDash
@onready var animations = $VerySeriousEnemy/EnemyAnimations
@onready var sfx = get_node("/root/MainGame/FancyCamera/SFX")
var min_wait_time = 0.5
var max_wait_time = 2.0
var final_wait_time
var previous_frame: Vector2
var max_power = 50
var min_power = 25
var max_amplifier = 3.0
var amplifier
var dash_time = 3
var dash_countdown
var can_dash = true
var candy_multiplier
var max_damage = 15
var hold_decay

func _ready() -> void:
	final_wait_time = randf_range(min_wait_time, max_wait_time)
	hold_decay = health.HealthDecay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var to_center = self.position.direction_to(center_stage.position)
	self.apply_force(to_center * center_stage.gravity)
	
	if center_stage.round_playing == true:
		health.HealthDecay = hold_decay
		health_bar.visible = true
		if can_dash == true:
			final_wait_time -= delta
			if final_wait_time < 0:
				can_dash = false
				dash_countdown = dash_time
				dash_graphic.visible = true
				pick_target(spinners.get_children())
		else:
			final_wait_time = randf_range(min_wait_time, max_wait_time)
			dash_countdown -= delta
			if dash_countdown < 0:
				can_dash = true
			elif dash_countdown < dash_time/3:
				dash_graphic.visible = false
		
		if health.CurrentHP > (health.MaxHp/2):
			animations.play("PlayerSpinHigh")
			candy_multiplier = 6
			amplifier = max_amplifier
		elif health.CurrentHP > (health.MaxHp/4):
			animations.play("PlayerSpinMed")
			candy_multiplier = 4
			if (max_amplifier/1.5) < 1:
				amplifier = 1
			else:
				amplifier = (max_amplifier/1.5)
		elif health.CurrentHP > 0:
			animations.play("PlayerSpinLow")
			candy_multiplier = 2
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
		health_bar.visible = false

	previous_frame = self.linear_velocity
	dash_graphic.rotation = previous_frame.angle()

func launch_self(target_position: Vector2):
	var direction_to_target = self.position.direction_to(target_position)
	var final_power = randi_range(min_power, max_power)
	var force = (direction_to_target * final_power).limit_length(max_power)
	self.apply_force(force * amplifier)

func pick_target(targets: Array):
	var active_spinners = targets.size()
	if active_spinners == 0:
		#If no one else is around, go in a random direction
		var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)) + self.position
		launch_self(random_direction)
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
			launch_self(chosen_target.position)

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
		self.health.heal(ceili(enemy_damage/2))
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
	if body.name != self.name and body is RigidBody2D:
		sfx.random_hurt_sound()
		steal_spin(body)

func spin_depleted():
	sfx.random_death_sound()
	spawner.kill_spinner(self)
