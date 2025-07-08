extends Node2D

var cafeSeats: Array[Node2D] = []


var customer = load("res://Customer.tscn")
var customers: Array[Customer] = []
func spawnCustomer():
	var path = $CafeLevel/CustomerPath
	var ticket_rail = $TicketRail
	var cust = customer.instantiate()
	cust.ticket_rail = ticket_rail
	if len(customers) > 0:
		cust.neighbor_ahead = customers[len(customers)-1]
	
	for s in cafeSeats:
		if not s.is_occupied():
			cust.set_seat(s, $CafeLevel/CafeEnv/CustomerNavMesh)
			break

	path.add_child(cust)
	customers.append(cust)
	
# Called when the node enters the scene tree for the first time.
var NUM_CUSTS = 10
var rng = RandomNumberGenerator.new()
var menu

var kitchen
var cafe

var level_mngr
func _ready():
	level_mngr = LevelManager.new()
	level_mngr.set_root(self)
	var levels: Array[Node] = [$CafeLevel, $KitchenLevel]
	level_mngr.set_levels(levels)
	level_mngr.switch_level($CafeLevel)
	
	
	cafe = $CafeLevel
	kitchen = $KitchenLevel
	kitchen.visible = false
	
	menu = $Menu
	
	menu.connect("kitchen_pressed", Callable(self, "_on_kitchen_button_pressed"))
	menu.connect("cafe_pressed", Callable(self, "_on_cafe_button_pressed"))
	
	for node in $CafeLevel.get_children():
		if node is CafeSeat:
			cafeSeats.append(node)
	cafeSeats.shuffle()
			
	$CafeLevel/CustomerPath/ExitZone.connect("body_entered", destroy)	
	for i in range(NUM_CUSTS):
		spawnCustomer()
		await get_tree().create_timer(rng.randf_range(0.5, 1.5)).timeout

func _on_kitchen_button_pressed():
	level_mngr.switch_level($KitchenLevel)
	pass
	
func _on_cafe_button_pressed():
	level_mngr.switch_level($CafeLevel)	
	pass

func destroy(body):
	var c = body.get_parent()
	if c in customers:
		customers.erase(c)
		c.queue_free()

func _process(delta):
	level_mngr.process(delta)
