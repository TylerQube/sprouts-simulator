extends Node2D
class_name OrderTicket


var item_sprite: Sprite2D
var item: Dictionary
func _ready():
	self.item_sprite = $Item as Sprite2D
	print(self.item_sprite)
	self.visible = false

func set_texture(item: Dictionary, path: String):
	self.item = item
	print(path)
	self.item_sprite.texture = load(path) as Texture2D
	
func display():
	print("show ticket")
	self.visible = true

func _process(delta: float):
	pass
