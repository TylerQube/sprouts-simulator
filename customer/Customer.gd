extends PathFollow2D
class_name Customer

var state: CustomerState

var seat: CafeSeat = null
var nav_mesh: NavigationRegion2D = null
var closest_point: Vector2
func set_seat(new_seat: CafeSeat, mesh: NavigationRegion2D):
	seat = new_seat
	seat.occupied = true
	nav_mesh = mesh



var anim
func set_anim(dir: Vector2):
	match dir:
		Vector2.RIGHT:
			anim.flip_h = false
			anim.play("walk_right")
		Vector2.LEFT:
			anim.flip_h = true
			anim.play("walk_right")
		Vector2.DOWN:
			anim.play("walk_down")
		Vector2.UP:
			anim.play('walk_up')
		_:
			anim.stop()
			anim.frame = 0
		
var wait: bool = false
func set_wait(val: bool):
	if val:
		wait = val
		return
	await get_tree().create_timer(rng.randf_range(0.4, 0.8)).timeout
	wait = val

func makeCardinal(vec: Vector2):
	if abs(vec.x) > abs(vec.y):
		vec.y = 0
	else:
		vec.x = 0
	return vec

func start_order(body):
	if body != $CharacterBody2D or not state is QueueState:
		return
	set_state(OrderState.new())
	
func detect_click(_viewport, event, _x):
	if !event.is_action_pressed("click") or not state is OrderState:
		return
	set_state(AwaitingOrderState.new())

var mouse_inside = false
func hover_enter():
	mouse_inside = true

func hover_exit():
	mouse_inside = false
	
var rng = RandomNumberGenerator.new()
var wait_dist = rng.randi_range(20, 27)
var speed = rng.randi_range(30, 40)
var menu
var speech_bubble
var order_item
var outline
var agent

func set_state(state: CustomerState):
	if self.state:
		self.state.exit()
	self.state = state
	self.state.setup(self)
	
var neighbor_ahead: Customer = null

var order: Order

func _ready():
	self.order = Order.new()
	self.order.setup(self)
	$CharacterBody2D/AnimatedSprite2D.material.set_shader_parameter("width", 0)
	self.speech_bubble = $CharacterBody2D/SpeechBubble
	order_item = $CharacterBody2D/SpeechBubble/Item	
	agent = $CharacterBody2D/NavigationAgent2D	
	
	set_state(QueueState.new())

func _process(delta: float):
	var old_pos = position
	state.update(delta)
	var dir = makeCardinal(position - old_pos).normalized()
	set_anim(dir)
