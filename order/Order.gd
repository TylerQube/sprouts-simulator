class_name Order

var customer: Customer
var item: Dictionary
var texture: Texture2D
var ticket: OrderTicket

const MENU_ITEMS = preload("res://order/MenuData.gd").items
const TEXTURE_DIR = "res://assets/order/items/"
const ticket_scene = preload("res://order_ticket.tscn")

func make_sprite(item: String):
	return TEXTURE_DIR + item + ".png"

func random_item():
	return MENU_ITEMS.pick_random()

func setup(customer: Customer):
	self.customer = customer
	self.item = random_item()
	var path = make_sprite(self.item.texture)
	self.texture = load(path) as Texture2D
	
	self.ticket = ticket_scene.instantiate()
	
	self.ticket.set_texture(item, path)
