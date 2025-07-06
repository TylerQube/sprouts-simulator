extends Sprite2D

signal kitchen_pressed
signal cafe_pressed

func _on_kitchen_button_pressed():
	set_room("kitchen")
	emit_signal("kitchen_pressed")

func _on_cafe_button_pressed():
	set_room("cafe")
	emit_signal("cafe_pressed")
	
var kitchen_button
var register_button

var btn_dict = {}
func _ready():
	kitchen_button = $KitchenButton
	register_button = $RegisterButton
	
	btn_dict["kitchen"] = kitchen_button
	btn_dict["cafe"] = register_button
	
	set_room("cafe")
	
	kitchen_button.pressed.connect(_on_kitchen_button_pressed)
	register_button.pressed.connect(_on_cafe_button_pressed)
	print("connected buttons")

func set_room(room: String):
	for b in btn_dict.values():
		b.set_pressed_no_signal(false)
		b.set_disabled(false)
		
	btn_dict[room].set_pressed_no_signal(true)
	btn_dict[room].set_disabled(true)
	
	
