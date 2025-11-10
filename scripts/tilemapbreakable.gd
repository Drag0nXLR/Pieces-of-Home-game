extends TileMap

@export var player_path: NodePath

func _process(delta):
	if player_path == null:
		return

	var player = get_node_or_null(player_path)
	var player_pos = player.global_position

	# Знаходимо клітинку, де стоїть гравець
	var cell = local_to_map(to_local(player_pos))

	# Беремо клітинку ліворуч від гравця
	var left_cell = Vector2i(cell.x - 1, cell.y)

	# Перевіряємо, чи там є тайл
	var tile_id = get_cell_source_id(0, left_cell)
	if tile_id != -1:
		# Видаляємо тільки цю клітинку
		set_cell(0, left_cell, -1)
