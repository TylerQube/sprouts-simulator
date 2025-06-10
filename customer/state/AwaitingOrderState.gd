extends CustomerState
class_name AwaitingOrderState

const DIR = preload("res://Seat.gd").DIRECTION

func setup(customer: Customer):
	self.customer = customer
	if customer.seat:
		customer.agent.target_position = customer.seat.global_position

enum { FindingSeat, Seated, GettingOrder }
var wait_state = FindingSeat

func update(delta: float):
	if not customer.seat:
		return
	if wait_state == FindingSeat:
		var dir = find_seat()
		customer.position += dir * customer.speed * delta
		if customer.agent.is_navigation_finished():
			wait_state = Seated
	else:
		customer.position = customer.seat.position		
		match customer.seat.direction:
			DIR.UP:
				customer.anim.play('sit_up')
			DIR.DOWN:
				pass
			DIR.RIGHT:
				customer.anim.play("sit_right")
			DIR.LEFT:
				customer.anim.play("sit_right")
				customer.anim.flip_h = true
	
func exit():
	pass

func find_seat():
	if not customer.seat or not customer.nav_mesh:
		return
	
	var target = customer.agent.get_next_path_position()
	var dir = (target - customer.global_position).normalized()
	customer.agent.set_velocity(dir * customer.speed)
	return dir
