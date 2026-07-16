extends Area2D

@onready var prompt: Label = $Prompt

var player_nearby: CharacterBody2D = null

func _ready() -> void:
	prompt.hide()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = body
		prompt.show()

func _on_body_exited(body: Node2D) -> void:
	if body == player_nearby:
		player_nearby = null
		prompt.hide()

func _process(_delta: float) -> void:
	if player_nearby != null and Input.is_action_just_pressed("interact"):
		player_nearby.has_key = true
		queue_free()
		
