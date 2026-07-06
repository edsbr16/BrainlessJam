extends CharacterBody2D

@export var speed: float = 100.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum Direction { DOWN, UP, SIDE }
var last_direction: Direction = Direction.DOWN
var current_hat: String = "bookkeeper"  # bookkeeper / decoder / chemist

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
		# TODO: actually check for nearby interactable and call its interact()

func get_facing_suffix() -> String:
	match last_direction:
		Direction.DOWN: return "down"
		Direction.UP: return "up"
		Direction.SIDE: return "side"
	return "down"

func switch_hat(new_hat: String) -> void:
	current_hat = new_hat
	# TODO: swap hat sprite overlay texture based on new_hat
