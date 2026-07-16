extends CharacterBody2D

var has_key: bool = false

@export var speed: float = 100.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $Area2D  # adjust name if yours is different
@onready var interact_prompt: Label = $InteractPrompt  # we'll add this node below

enum Direction { DOWN, UP, SIDE }
var last_direction: Direction = Direction.DOWN
var current_hat: String = "bookkeeper"
var nearby_interactable = null

func _ready() -> void:
	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)
	interact_prompt.visible = false

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
	move_and_slide()
	update_animation(input_dir)

func update_animation(input_dir: Vector2) -> void:
	var moving = input_dir.length() > 0.1
	if input_dir.x < -0.1:
		last_direction = Direction.SIDE
		sprite.flip_h = true
	elif input_dir.x > 0.1:
		last_direction = Direction.SIDE
		sprite.flip_h = false
	elif input_dir.y < -0.1:
		last_direction = Direction.UP
	elif input_dir.y > 0.1:
		last_direction = Direction.DOWN

	var anim_name = ""
	match last_direction:
		Direction.DOWN:
			anim_name = "walk_down" if moving else "idle_down"
		Direction.UP:
			anim_name = "walk_up" if moving else "idle_up"
		Direction.SIDE:
			anim_name = "walk_side" if moving else "idle_side"

	if sprite.animation != anim_name:
		sprite.play(anim_name)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		sprite.play("interact_" + get_facing_suffix())
		if nearby_interactable and nearby_interactable.has_method("interact"):
			nearby_interactable.interact()

func get_facing_suffix() -> String:
	match last_direction:
		Direction.DOWN: return "down"
		Direction.UP: return "up"
		Direction.SIDE: return "side"
	return "down"

func switch_hat(new_hat: String) -> void:
	current_hat = new_hat

func _on_area_entered(area: Area2D) -> void:
	print("Something entered: ", area.name)
	if area.has_method("interact"):
		nearby_interactable = area
		interact_prompt.visible = true

func _on_area_exited(area: Area2D) -> void:
	if area == nearby_interactable:
		nearby_interactable = null
		interact_prompt.visible = false
		
