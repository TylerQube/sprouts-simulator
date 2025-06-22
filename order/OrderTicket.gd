extends Node2D
class_name OrderTicket


var item_sprite: Sprite2D
var paper_sprite: Sprite2D
var item: Dictionary
var path
func _ready():
	self.item_sprite = $Ticket/Item as Sprite2D
	self.paper_sprite = $Ticket as Sprite2D

func set_texture(item: Dictionary, path: String):
	await self.ready
	self.item = item
	self.item_sprite.texture = load(path) as Texture2D
	self.path = path
	
func _process(delta: float):
	pass
