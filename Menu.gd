extends Sprite2D

func _on_kitchen_button_pressed():
	emit_signal("kitchen_pressed")

func _on_register_button_pressed():
	emit_signal("register_pressed")
	
var kitchen_button
var register_button

var btn_dict = {}
func _ready():
	kitchen_button = $KitchenButton
	register_button = $RegisterButton
	
	btn_dict["kitchen"] = kitchen_button
	btn_dict["register"] = register_button

func set_room(room: String):
	for b in btn_dict.values():
		b.set_pressed_no_signal(false)
		b.set_disabled(false)
		
	btn_dict[room].set_pressed_no_signal(true)
	btn_dict[room].set_disabled(true)
	
	
