extends Control

func _ready() -> void:
	$SlidingPuzzle/GridContainer.solved.connect(_on_puzzle_solved)

func show_clue() -> void:
	visible = true

func hide_clue() -> void:
	visible = false

func _on_puzzle_solved() -> void:
	$TitleLabel.visible = false
	$InstructionLabel.visible = false
	$SlidingPuzzle.visible = false
	$ReferenceImage.visible = false
	$BookImage.visible = false
	$SuccessLabel.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("interact"):
		hide_clue()
