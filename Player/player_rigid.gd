extends RigidBody2D

var mouse_position
var amplifier = 1.5
var max_power = 60
var dash_time = 5
var candy_multiplier
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
				var hit_box_limit = self.position - mouse_position
				hit_box.position = hit_box_limit.limit_length(1)
				hit_box.rotation = hit_box.position.angle()
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
	elif health.CurrentHP > fourth_health:
		animations.play("PlayerSpinMed")
		candy_multiplier = 2
	elif health.CurrentHP > 0:
		animations.play("PlayerSpinLow")
		candy_multiplier = 1
	else:
		animations.stop()
		candy_multiplier = 0

	var to_center = self.position.direction_to(center_stage.position)
	var distance_to_center = self.position.distance_squared_to(center_stage.position)
	self.apply_force(to_center * center_stage.gravity)

func steal_spin(enemy: RigidBody2D):
	print(enemy.bah)
	pass

func _on_damage_area_entered(body: RigidBody2D) -> void:
	if body.name != "Player":
		steal_spin(body)
