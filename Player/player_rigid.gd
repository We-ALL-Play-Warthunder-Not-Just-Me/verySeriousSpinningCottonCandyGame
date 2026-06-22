extends RigidBody2D

var mouse_position
var amplifier = 1.5
var max_power = 60
var candy_multiplier
@onready var draw_arrow = $VerySeriousArrows3
@onready var health = $HealthComponent
@onready var animations = $VerySeriousPlayer/PlayerAnimations
@onready var half_health = health.MaxHp/2
@onready var fourth_health = health.MaxHp/4
@onready var half_power = max_power/2
@onready var fourth_power = max_power/4
var can_dash = true
@export var temp_time = Node2D
var aiming = false
@export var temp_world = Node2D

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
				temp_time.start(temp_time.wait_time)
				self.set_linear_velocity(Vector2(0,0))
				Engine.set_time_scale(1.0)
				draw_arrow.visible = false
				var force = (self.position - mouse_position)
				var lim_force = force.limit_length(max_power)
				self.apply_force(lim_force * amplifier)
				#print(force)
				#print(lim_force)
	
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

	var to_center = self.position.direction_to(temp_world.position)
	self.apply_force(to_center * temp_world.gravity)

func _on_dash_timer_timeout() -> void:
	can_dash = true
