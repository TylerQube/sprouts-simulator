extends Node2D
const TICKET_GAP_PX = 2
const MAX_TICKETS = 4
var ticket_width
var tickets: Array[OrderTicket] # tickets on visible rail
var ticket_queue: Array[OrderTicket] # overflow tickets
var is_animating: bool = false

func is_rail_full():
	return num_tickets() >= 4

func last_ticket():
	var tix = tickets.filter(func(t): return t)
	if len(tix) == 0:
		return null
	return tix[len(tix) - 1]

func num_tickets():
	return len(tickets.filter(func(t): return t))

func add_ticket(ticket: OrderTicket):
	if is_rail_full():
		ticket_queue.append(ticket)
		return
		
	var first_gap = tickets.find(null)
		
	# slide tickets to the right
	for i in range(first_gap, 0, -1):
		if tickets[i-1] == null:
			continue
		tickets[i] = tickets[i-1]
		await slide_ticket(tickets[i])	
	
	tickets[0] = ticket
	
	self.add_child(ticket)
	
	ticket.get_node("Ticket/ClickArea").connect("input_event", detect_click.bind(ticket))
	ticket_width = ticket.paper_sprite.texture.get_size().x
	ticket.position = Vector2(-40, 0)
	
	slide_ticket(ticket)

func remove_ticket(ticket: OrderTicket, success: bool = false):
	var ind = tickets.find(ticket)
	
	var player = ticket.get_node("AnimationPlayer")
	tickets[ind] = null
	
	if success:
		player.play("yank")
		await player.animation_finished
		remove_child(ticket)
	else:
		print("failed ticket!")
		fail_ticket(ticket)
		await get_tree().create_timer(2).timeout
		
		
	
	for i in range(ind, 0, -1):
		if tickets[i-1] == null:
			continue
		print("sliding right after removal...")
		tickets[i] = tickets[i-1]
		tickets[i-1] = null
		await slide_ticket(tickets[i])
	
	
	if not is_rail_full():
		var next_ticket = ticket_queue.pop_front()
		if next_ticket == null:
			return
		add_ticket(next_ticket)
		
func fail_ticket(ticket: OrderTicket):
	print(ticket.position.x)
	var ticket_offset = (ticket_width + TICKET_GAP_PX)
	ticket.position.x += 28
	ticket.get_node("Ticket").position.x = 0
	var player = ticket.get_node("AnimationPlayer")
	player.speed_scale = 1
	player.play("fall_2")
	await player.animation_finished
	remove_child(ticket)
	

func print_tix():
	for i in range(len(tickets)):
		var t = tickets[i]
		if t == null:
			print("Slot ", i, ": null")
		else:
			print("Slot ", i, " item: ", t.path, " pos=", t.position, )

func slide_ticket(ticket: OrderTicket):
	var ticket_offset = (ticket_width + TICKET_GAP_PX)
	var ticket_sprite = ticket.get_node("Ticket")
	print(ticket_sprite.global_position)
	ticket.position.x += ticket_offset
	ticket_sprite.position.x = ticket_width / 2
	print(ticket_sprite.global_position)
	print()
	ticket.get_node("AnimationPlayer").play("slide_in")
	await get_tree().create_timer(0.1).timeout

func detect_click(viewport: Viewport, event: InputEvent, shape_idx: int, ticket: OrderTicket):
	if !event.is_action_pressed("click"):
		return
	remove_ticket(ticket)

func _ready():
	tickets.resize(MAX_TICKETS)
	tickets.fill(null)
	ticket_queue = []

func _process(delta):
	pass
