# Door.gd — attach to the Entryway Area2D
extends Area2D

@export var locked: bool = true
@export var next_scene_path: String = "res://scenes/room2_decoder/room2.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":  # adjust to match your actual player node name
		return
	if locked:
		print("The door is locked. Solve the puzzle first!")
		return
	get_tree().change_scene_to_file(next_scene_path)

func unlock() -> void:
	locked = false
	print("Door unlocked!")

func interact() -> void:
	get_tree().call_group("door", "unlock")
