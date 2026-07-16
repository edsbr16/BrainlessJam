# clue_object.gd — attach to the Area2D over the book/clue-object
extends Area2D

func interact() -> void:
	get_tree().call_group("ui", "show_clue")
