extends Camera2D

@export var center_stage: Node2D
@onready var spinners = get_node("/root/MainGame/Spinners")
@onready var follow_this = center_stage
@onready var smooth_zoom = self.get_zoom().x
@onready var target_zoom = CENTER_ZOOM
var follow_player = false
const PLAYER_ZOOM = 2.8
const CENTER_ZOOM = 2.0
const ZOOM_SPEED = 1.5



func start_camera():
	var player = spinners.get_child(3)
	follow_this = player
	smooth_zoom = self.get_zoom().x
	target_zoom = PLAYER_ZOOM
	follow_player = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = follow_this.position
	if follow_player == true:
		smooth_zoom += (ZOOM_SPEED * delta)
		if smooth_zoom >= target_zoom:
			self.set_zoom(Vector2(target_zoom, target_zoom))
		else:
			self.set_zoom(Vector2(smooth_zoom, smooth_zoom))
	else:
		smooth_zoom -= (ZOOM_SPEED * delta)
		if smooth_zoom <= target_zoom:
			self.set_zoom(Vector2(target_zoom, target_zoom))
		else:
			self.set_zoom(Vector2(smooth_zoom, smooth_zoom))

func switch_camera_points(node: Node):
	follow_this = node
	smooth_zoom = self.get_zoom().x
	print(center_stage.round_playing)
	if node.name == "Player":
		follow_player = true
		target_zoom = PLAYER_ZOOM
	else:
		follow_player = false
		target_zoom = CENTER_ZOOM
	

func _on_spinners_child_entered_tree(node: Node) -> void:
	print(node)
	if node.name == "Player" and center_stage.round_playing:
		switch_camera_points(node)

func _on_spinners_child_exiting_tree(node: Node) -> void:
	print(node)
	if node.name == "Player":
		switch_camera_points(center_stage)
