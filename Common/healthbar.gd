extends ProgressBar

@export var damagebar: ProgressBar
@export var timer: Timer
@export var health: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.CurrenthealthChanged.connect(updateHealthBarCurrentHP)
	health.MaxHPChanged.connect(updateMaxHealth)
	health.healthDEATH.connect(onDeath)
	timer.timeout.connect(_onTimerTimeout)
	
	# Inital health bar
	if health == null:
		value = 100
		max_value = 100
		damagebar.value = 100
		damagebar.max_value = 100
	else:
		value = health.CurrentHP
		max_value = health.MaxHP
		damagebar.value = health.CurrentHP
		damagebar.max_value = health.MaxHP

func updateHealthBarCurrentHP(newHP: int, oldHP: int) -> void:
	# damagebar.value = oldHP
	# value = newHP
	# if value <= 0:
	# 	pass # Something happens but a health Death signal does exist
	# if newHP < oldHP:
	# 	timer.start()
	# else:
	# 	damagebar.value = value
	if newHP <= oldHP:
		value = newHP
		timer.start()
	elif newHP > oldHP: #When you regain health waow waow waow
		damagebar.value = newHP
		await get_tree().create_timer(timer.wait_time).timeout # Suspect timer
		value = newHP
	else:
		damagebar.value = value

func onDeath() -> void:
	queue_free()

func updateMaxHealth(newMax: int, oldMax: int) -> void:
	max_value = newMax
	damagebar.max_value = newMax

func _onTimerTimeout() -> void:
	damagebar.value = value
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
