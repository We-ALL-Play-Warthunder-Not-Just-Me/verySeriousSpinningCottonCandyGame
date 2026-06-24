extends Camera2D

@onready var center_stage = get_node("/root/MainGame/CenterStage")
@onready var spinners = get_node("/root/MainGame/Spinners")
var follow_this = Node
var follow_player = false
const PLAYER_ZOOM = 2.8
const CENTER_ZOOM = 2.0
const ZOOM_SPEED = 1.5
var smooth_zoom
var target_zoom

func _ready() -> void:
	var player = spinners.get_child(3)
	follow_this = player
	follow_player = true
	smooth_zoom = self.get_zoom().x
	target_zoom = PLAYER_ZOOM

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
	if node.name == "Player":
		follow_player = true
		target_zoom = PLAYER_ZOOM
	else:
		follow_player = false
		target_zoom = CENTER_ZOOM
	

func _on_spinners_child_entered_tree(node: Node) -> void:
	print(node)
	if node.name == "Player":
		switch_camera_points(node)

func _on_spinners_child_exiting_tree(node: Node) -> void:
	print(node)
	if node.name == "Player":
		switch_camera_points(center_stage)
