extends CharacterBody2D

@export var speed = 70

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
func _ready():
	old_pos = position
	pos = position

func _physics_process(delta):
	old_pos = position
	var dir = get_input()
	velocity = dir * speed
	move_and_slide()
	pos = position
	set_anim(dir, (pos - old_pos).length_squared() > tol)
	
	
