extends Node

class_name LevelManager

var root: Node2D
var player: Node2D
var current_level: Node2D
var next_level: Node2D
var levels: Array[Node]

var leaving: bool

func set_root(root: Node2D):
	self.root = root
	self.player = root.get_node("Player")

func set_levels(levels: Array[Node]):
	self.levels = levels
	
func switch_level(new_level: Node):
	# leave current level
	if current_level:
		leaving = true
		print(current_level)
		var exit_point = self.current_level.get_node("EnterPoint").position
		self.player.agent.target_position = exit_point
	else:
		next_level = new_level
		_transition_level()
	next_level = new_level
	
func _transition_level():
	if not next_level:
		return
	if current_level:
		var ci = levels.find(current_level) + 1
		_set_level_enabled(current_level, false, ci)
		current_level.visible = false
	var li = levels.find(next_level) + 1
	_set_level_enabled(next_level, true, li)
	next_level.visible = true
	current_level = next_level
	next_level = null
	
	player.collision_layer = li
	for i in range(1, len(levels)+1):
		player.set_collision_mask_value(i, false)
	player.set_collision_mask_value(li, true)
	
	
	var entry_point = current_level.get_node("EnterPoint").global_position
	player.global_position = entry_point
	
	var point
	if current_level.name == "KitchenLevel":
		point = current_level.get_node("BreakfastPoint")
	elif current_level.name == "CafeLevel":
		point = current_level.get_node("RegisterPoint")
	print(str(point))
	player.agent.target_position = point.position
	

func _set_level_enabled(level: Node, enabled: bool, layer: int):
	for c in level.get_children():
		if c is Area2D:
			c.collision_layer = layer
		_set_level_enabled(c, enabled, layer)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	leaving = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	print(player.agent.is_navigation_finished())
	print("reachable: "+ str(player.agent.is_target_reachable()))
	if leaving and player.agent.is_navigation_finished():
		var path = player.agent.get_current_navigation_path()
		var target = player.agent.target_position
		var cur = player.position
		leaving = false
		_transition_level()
