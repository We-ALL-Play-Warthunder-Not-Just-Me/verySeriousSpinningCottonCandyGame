extends ProgressBar

@export var damagebar: ProgressBar
@export var timer: Timer
@onready var recharge_timer = $RechargeIntervals
var recharge_rate = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_onTimerTimeout)
	# Inital stamina bar
	value = 50
	max_value = 50
	damagebar.value = 50
	damagebar.max_value = 50

func takeDamage(damage: int) -> void:
	var old: int = value
	value -= damage
	updateStaminaBar(value, old)

func updateStaminaBar(newStam: int, oldStam: int) -> void:
	if newStam <= oldStam:
		value = newStam
		timer.start()
		recharge_timer.start()
	#elif newStam > oldStam: #When you regain health waow waow waow | Don't mind me, just borrowing all this - G
		#damagebar.value = newStam
		#await get_tree().create_timer(timer.wait_time).timeout # Suspect timer
		#value = newStam
	else:
		damagebar.value = value

func updateMaxStam(newMax: int, oldMax: int) -> void:
	max_value = newMax
	damagebar.max_value = newMax

func _onTimerTimeout() -> void:
	damagebar.value = value

func recharge_timer_tick():
	if max_value > value:
		print("Refilling...")
		value += recharge_rate
		recharge_timer.start()
