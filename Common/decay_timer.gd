extends Timer
class_name decayTimer

@export var health: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(_onTimerTimeout)

func _onTimerTimeout() -> void:
	health.takeDamage(health.HealthDecay)
