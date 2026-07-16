extends GridContainer

const GRID_SIZE = 4
var tiles: Array = []
var piece_ids: Array = []  # tracks which "correct piece" is in each slot
var empty_index: int = 15

func _ready() -> void:
	columns = GRID_SIZE  # ensures GridContainer wraps into 4 columns

	tiles = get_children()

	# Assign each tile its correct "home" ID (0-15) based on starting order
	for i in range(tiles.size()):
		piece_ids.append(i)
		tiles[i].pressed.connect(_on_tile_pressed.bind(i))

	# Hide the empty tile visually (make it blank)
	tiles[empty_index].texture_normal = null
	tiles[empty_index].disabled = true

	shuffle_puzzle(20)

func _on_tile_pressed(index: int) -> void:
	if is_adjacent(index, empty_index):
		swap_tiles(index, empty_index)
		empty_index = index
		check_win()

func is_adjacent(a: int, b: int) -> bool:
	var a_row = a / GRID_SIZE
	var a_col = a % GRID_SIZE
	var b_row = b / GRID_SIZE
	var b_col = b % GRID_SIZE
	return (abs(a_row - b_row) + abs(a_col - b_col)) == 1

func swap_tiles(a: int, b: int) -> void:
	var temp_texture = tiles[a].texture_normal
	tiles[a].texture_normal = tiles[b].texture_normal
	tiles[b].texture_normal = temp_texture

	var temp_id = piece_ids[a]
	piece_ids[a] = piece_ids[b]
	piece_ids[b] = temp_id

	tiles[a].disabled = (piece_ids[a] == 15)
	tiles[b].disabled = (piece_ids[b] == 15)

func get_valid_neighbors(index: int) -> Array:
	var neighbors = []
	var row = index / GRID_SIZE
	var col = index % GRID_SIZE
	if row > 0: neighbors.append(index - GRID_SIZE)
	if row < GRID_SIZE - 1: neighbors.append(index + GRID_SIZE)
	if col > 0: neighbors.append(index - 1)
	if col < GRID_SIZE - 1: neighbors.append(index + 1)
	return neighbors

func shuffle_puzzle(moves: int) -> void:
	for i in range(moves):
		var neighbors = get_valid_neighbors(empty_index)
		var random_neighbor = neighbors[randi() % neighbors.size()]
		swap_tiles(random_neighbor, empty_index)
		empty_index = random_neighbor

func check_win() -> void:
	for i in range(piece_ids.size()):
		if piece_ids[i] != i:
			return
	on_puzzle_solved()

func on_puzzle_solved() -> void:
	# Hide the puzzle elements
	visible = false  # hides the GridContainer itself (this script is attached to it)
	get_parent().get_node("PuzzleView").visible = false
	get_parent().get_node("SuccessView").visible = true
	
	get_tree().call_group("door", "unlock")
