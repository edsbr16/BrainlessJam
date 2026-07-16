extends Control

# Load door images into memory
var closed_door = preload("res://Assets/Main_menu/Doors/doubleDoors-closed.png")
var open_door = preload("res://Assets/Main_menu/Doors/doubleDoors-open.png")

# Reference to door image node
@onready var door_node = $"Door Image"

func open_on_hover():
	# Change to open door image when mouse hovers
	door_node.texture = open_door
	
func close_no_hover():
	# Change to closed door image when mouse leaves
	door_node.texture = closed_door

func play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/room1_bookkeeper/room1.tscn")
	
	
