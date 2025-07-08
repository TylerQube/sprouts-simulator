extends CharacterBody2D

@export var speed = 60

@export var left_tex: Texture
@export var right_tex: Texture
@export var up_tex: Texture
@export var down_tex: Texture

func get_input():
	var dir = Input.get_vector("left", "right", "up", "down")
	if abs(dir.x) > abs(dir.y):
		dir.y = 0
	else:
		dir.x = 0
	return dir
	
func get_cardinal(vec: Vector2):
	if abs(vec.x) > abs(vec.y):
		return Vector2.RIGHT if vec.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if vec.y > 0 else Vector2.UP

func set_anim(dir: Vector2, moved: bool):
	var anim = $AnimatedSprite2D
	if dir == Vector2.RIGHT:
		anim.flip_h = false
		anim.play("walk_right")
	elif dir == Vector2.LEFT:
		anim.flip_h = true
		anim.play("walk_right")
	elif dir == Vector2.DOWN:
		anim.play("walk_down")
	elif dir == Vector2.UP:
		anim.play('walk_up')
	else:
		anim.stop()
		anim.frame = 0
	if !moved:
		anim.stop()
		anim.frame = 0
		

var old_pos : Vector2
var pos : Vector2
var tol = 1e-4

var agent: NavigationAgent2D
func _ready():
	old_pos = position
	agent = $NavigationAgent2D

func _physics_process(delta):
	old_pos = position
	var to_dest = self.agent.get_next_path_position() - old_pos
	var dir = to_dest.normalized()
	
	
	if to_dest.length_squared() > 1:
		velocity = dir * speed
		move_and_slide()
	

	var moved = (position - old_pos).length_squared() > tol
	set_anim(get_cardinal(dir), moved)
	
	
