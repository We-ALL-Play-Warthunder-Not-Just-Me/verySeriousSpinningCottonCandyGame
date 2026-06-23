extends Label

@onready var countdown = $Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(countdown.time_left)
	self.text = str(ceili(countdown.time_left))
