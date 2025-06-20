extends Node2D

const TICKET_GAP_PX = 2
const MAX_TICKETS = 4

var ticket_width

func add_ticket(ticket: OrderTicket):
	self.add_child(ticket)
	ticket.get_node("Ticket/ClickArea").connect("input_event", _detect_click.bind(ticket))
	ticket_width = ticket.paper_sprite.texture.get_size().x
	ticket.global_position = global_position
	ticket.global_position.x = -15
	
	var num_overflow = max(0, len(tickets) - MAX_TICKETS)
	ticket.global_position.x -= 26 * num_overflow
	ticket.global_position.y += 2
	
	tickets.append(ticket)	
	
	if len(tickets) <= MAX_TICKETS:
		await slide_tickets(tickets.slice(0, -1))
		ticket.get_node("AnimationPlayer").play("slide_in")
	
	
func slide_tickets(arr: Array[OrderTicket]):
	var ticket_offset = (ticket_width + TICKET_GAP_PX)
	for t in arr:
		t.position.x += ticket_offset
		t.get_node("Ticket").position.x = 0
		t.get_node("AnimationPlayer").play("slide_in")
		await get_tree().create_timer(0.1).timeout

func _detect_click(viewport: Viewport, event: InputEvent, shape_idx: int, ticket: OrderTicket):
	if !event.is_action_pressed("click"):
		return
	print("clicked")
	
	ticket.get_node("AnimationPlayer").play("yank")
	await ticket.get_node("AnimationPlayer").animation_finished
	
	var ind = tickets.find(ticket)
	if ind < len(tickets)-1:
		await slide_tickets(tickets.slice(ind+1, len(tickets)))
	tickets.pop_at(ind)
	remove_child(ticket)
	
var tickets: Array[OrderTicket]
func _ready():
	tickets = []
	
	

func _process(delta):
	pass
