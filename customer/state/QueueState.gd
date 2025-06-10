extends CustomerState
class_name QueueState

func setup(cust: Customer):
	customer = cust
	customer.anim = customer.get_node("CharacterBody2D/AnimatedSprite2D")
	customer.speech_bubble = customer.get_node("CharacterBody2D/SpeechBubble")
	customer.speech_bubble.visible = false
	
	# random offset
	customer.anim.position.x = customer.rng.randi_range(-1, 1)
	customer.anim.position.y = customer.rng.randi_range(-1, 1)
	
	# Connect event signals
	customer.get_node("../OrderZone").connect("body_entered", customer.start_order)
	customer.get_node("CharacterBody2D/ClickArea").connect("input_event", customer.detect_click)
	customer.get_node("CharacterBody2D/ClickArea").connect("mouse_entered", customer.hover_enter)
	customer.get_node("CharacterBody2D/ClickArea").connect("mouse_exited", customer.hover_exit)

func update(delta):
	customer.set_wait(false)
	if customer.neighbor_ahead and not customer.neighbor_ahead.state is QueueState and not customer.neighbor_ahead.state is OrderState:
		customer.neighbor_ahead = null
	if customer.neighbor_ahead:
		var d = customer.neighbor_ahead.get_progress() - customer.get_progress()
		if d < customer.wait_dist + 5:
			customer.speed = customer.neighbor_ahead.speed
		customer.set_wait(d < customer.wait_dist)
		
	if not customer.wait:
		customer.set_progress(customer.get_progress() + customer.speed * delta)
	else:
		customer.anim.stop()
		customer.anim.frame = 0
	
func exit():
	pass
