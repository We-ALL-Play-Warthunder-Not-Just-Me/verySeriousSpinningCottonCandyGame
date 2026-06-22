extends RigidBody2D

var mouse_position
var amplifier = 350
var max_power = 60
@onready var draw_arrow = $VerySeriousArrows3
@onready var red_arrow = load("res://Assets/Images/Very Serious Arrows1.png")
@onready var yellow_arrow = load("res://Assets/Images/Very Serious Arrows2.png")
@onready var green_arrow = load("res://Assets/Images/Very Serious Arrows3.png")
@onready var health = $HealthComponent
@onready var animations = $VerySeriousPlayer/PlayerAnimations

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MouseLeftClick"):
		self.set_linear_velocity(Vector2(0,0))

	if Input.is_action_pressed("MouseLeftClick"):
		draw_arrow.visible = true
		mouse_position = get_global_mouse_position()
		var draw_arrow_limit = self.position - mouse_position
		draw_arrow.position = draw_arrow_limit.limit_length(max_power)
		draw_arrow.rotation = draw_arrow.position.angle()
		if draw_arrow_limit.length() > 30:
			draw_arrow.texture = green_arrow
		elif draw_arrow_limit.length() > 15:
			draw_arrow.texture = yellow_arrow
		elif draw_arrow_limit.length() > 0:
			draw_arrow.texture = red_arrow
		#print("Hold!")
		#print("Mouse Position: ", mouse_position)
		
	if Input.is_action_just_released("MouseLeftClick"):
		print("Send!")
		draw_arrow.visible = false
		var force = (self.position - mouse_position)
		var lim_force = force.limit_length(max_power)
		self.apply_force(lim_force * amplifier)
		#print(force)
		#print(lim_force)
	
	if health.CurrentHP > 50:
		animations.play("PlayerSpinHigh")
	elif health.CurrentHP > 25:
		animations.play("PlayerSpinMed")
	elif health.CurrentHP > 0:
		animations.play("PlayerSpinLow")
	else:
		animations.stop()
