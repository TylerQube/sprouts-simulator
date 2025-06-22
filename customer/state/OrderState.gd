extends CustomerState
class_name OrderState

const TEXTURE_DIR = "res://assets/order/items/"

var cust_sprite

func setup(customer: Customer):
	self.customer = customer
	self.customer.order_item.texture = self.customer.order.texture
	self.customer.speech_bubble.visible = true
	self.cust_sprite = customer.get_node("CharacterBody2D/AnimatedSprite2D")

func update(delta: float):
	var is_outlined = 1 if customer.mouse_inside else 0
	self.cust_sprite.material.set_shader_parameter("width", is_outlined)
	
	customer.anim.stop()
	customer.anim.frame = 0
	
func exit():
	customer.speech_bubble.visible = false
	self.cust_sprite.material.set_shader_parameter("width", 0)
	self.customer.ticket_rail.add_ticket(self.customer.order.ticket)

