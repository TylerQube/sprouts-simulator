extends Node2D
class_name OrderTicket


var item_sprite: Sprite2D
var paper_sprite: Sprite2D
var item: Dictionary
func _ready():
	self.item_sprite = $Ticket/Item as Sprite2D
	self.paper_sprite = $Ticket as Sprite2D
	print(self.item_sprite)

func set_texture(item: Dictionary, path: String):
	await self.ready
	self.item = item
	print(path)
	self.item_sprite.texture = load(path) as Texture2D
	
func _process(delta: float):
	pass
