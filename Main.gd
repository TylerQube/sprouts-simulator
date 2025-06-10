extends Node2D

var cafeSeats: Array[Node2D] = []

var customer = load("res://Customer.tscn")
var customers: Array[Customer] = []
func spawnCustomer():
	var path = $CustomerPath
	var cust = customer.instantiate()
	if len(customers) > 0:
		cust.neighbor_ahead = customers[len(customers)-1]
	
	for s in cafeSeats:
		if not s.is_occupied():
			cust.set_seat(s, $Cafe/CustomerNavMesh)
			break

	path.add_child(cust)
	customers.append(cust)

# Called when the node enters the scene tree for the first time.
var NUM_CUSTS = 10
var rng = RandomNumberGenerator.new()
func _ready():
	for node in get_children():
		if node is CafeSeat:
			cafeSeats.append(node)
	cafeSeats.shuffle()
			
	$CustomerPath/ExitZone.connect("body_entered", destroy)	
	for i in range(NUM_CUSTS):
		spawnCustomer()
		await get_tree().create_timer(rng.randf_range(0.5, 1.5)).timeout


func destroy(body):
	var c = body.get_parent()
	if c in customers:
		customers.erase(c)
		c.queue_free()

func _process(delta):
	pass
