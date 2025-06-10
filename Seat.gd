extends Node2D
class_name CafeSeat

var occupied = false

enum DIRECTION { UP, DOWN, LEFT, RIGHT }
@export var direction: DIRECTION

func is_occupied() -> bool:
	return occupied

func set_occupied(val):
	occupied = val

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
