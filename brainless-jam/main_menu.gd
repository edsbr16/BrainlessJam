extends Control

# Load door images into memory
var closed_door = preload("res://Assets/Main_menu/door_closed.png")
var open_door = preload("res://Assets/Main_menu/door_open.png")

# Reference to door image node
@onready var door_node = $"Door Image"

func open_on_hover():
	# Change to open door image when mouse hovers
	door_node.texture = open_door
	
func close_no_hover():
	# Change to closed door image when mouse leaves
	door_node.texture = closed_door
	
	
