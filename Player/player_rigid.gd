extends spinnerBase

var mouse_position




@onready var draw_arrow = $VerySeriousArrows3
@onready var animations = $VerySeriousPlayer/PlayerAnimations
@onready var hit_box = $DamageArea/PlayerHitBox

var aiming = false

@onready var candy_tracker = get_node("/root/MainGame/CottonCandyTracker")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if center_stage.round_playing == true:
		if health.CurrentHP > (health.MaxHp/2):
			animations.play("PlayerSpinHigh")
			candy_multiplier = 3
			amplifier = max_amplifier
		elif health.CurrentHP > (health.MaxHp/4):
			animations.play("PlayerSpinMed")
			candy_multiplier = 2
			amplifier = (max_amplifier/2)
		elif health.CurrentHP > 0:
			animations.play("PlayerSpinLow")
			candy_multiplier = 1
			amplifier = (max_amplifier/4)
		else:
			animations.stop()
			
	else:
		self.linear_velocity.lerp(Vector2(0,0),30)
		candy_tracker.candy_multiplier = 0
		health.HealthDecay = 0

	
	

func Dash_Logic(delta:float):
	if center_stage.round_playing == true:
		if dash_ready == true:
			if Input.is_action_just_pressed("MouseLeftClick"):
				Engine.set_time_scale(0.1)
				aiming = true
			if aiming == true:
				if Input.is_action_pressed("MouseLeftClick"):
					draw_arrow.visible = true
					mouse_position = get_global_mouse_position()
				if Input.is_action_just_released("MouseLeftClick"):
					aiming = false
					Engine.set_time_scale(1.0)
					draw_arrow.visible = false
					Dash((self.position - mouse_position))


#func steal_spin(enemy: RigidBody2D):
	#var player_force = abs(previous_frame.length())
	#var enemy_force = abs(enemy.previous_frame.length())
	#if player_force > enemy_force:
		#print("We got 'em!")
		#var force_total = (player_force + enemy_force)
		#var force_difference =  (player_force - enemy_force)
		#var force_percent = force_difference / force_total
		#var enemy_damage = ceili(max_damage * force_percent)
		#enemy.health.takeDamage(enemy_damage)
		#self.health.heal(ceili(enemy_damage/2))
		##print("Player Force: ", player_force)
		##print("Enemy Force: ", enemy_force)
		##print("Total Force: ", force_total)
		##print("The Difference: ", force_difference)
		##print("Force Percentage: ", force_percent)
		##print("Enemy Current HP: ", enemy.health.CurrentHP)
		##print("Enemy HP to lose: ", enemy_damage)
	#elif player_force < enemy_force:
		#print("We're not strong enough...")

#func _on_damage_area_entered(body: Node2D) -> void:
	#print("boop")
	#if body.name != self.name and body is RigidBody2D:
		#steal_spin(body)
#
#func spin_depleted():
	#spawner.kill_spinner(self)
