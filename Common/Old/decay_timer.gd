extends Timer

## A timer that connects to health component and makes them take damage based on their Health decay value
class_name decayTimer

@export var health: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(_onTimerTimeout)
	autostart = true

func _onTimerTimeout() -> void:
	health.takeDamage(health.HealthDecay)
