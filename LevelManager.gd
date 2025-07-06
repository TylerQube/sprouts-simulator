extends Node

class_name LevelManager

var root: Node2D
var player: Node2D
var current_level: Node2D
var levels: Array[Node]

func set_root(root: Node2D):
	self.root = root
	self.player = root.get_node("Player")

func set_levels(levels: Array[Node]):
	self.levels = levels
	
func switch_level(new_level: Node):
	if current_level:
		var ci = levels.find(current_level) + 1
		_set_level_enabled(current_level, false, ci)
		current_level.visible = false
	var li = levels.find(new_level) + 1
	_set_level_enabled(new_level, true, li)
	new_level.visible = true
	current_level = new_level
	
	player.collision_layer = li
	for i in range(1, len(levels)+1):
		player.set_collision_mask_value(i, false)
	player.set_collision_mask_value(li, true)

	
	# new_level.visible = true
	#_set_level_enabled(new_level, true)
	

func _set_level_enabled(level: Node, enabled: bool, layer: int):
	for c in level.get_children():
		if c is Area2D:
			c.collision_layer = layer
		_set_level_enabled(c, enabled, layer)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
