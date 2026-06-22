extends Node

class_name upgrade_manager

@export var upgrades: playerUpgrades = load("res://Player/Upgrades.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if upgrades == null:
		upgrades.new()
		ResourceSaver.save(upgrades, "res://Player/Upgrades.tres")


func applyMaxSpinUpgrade() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
