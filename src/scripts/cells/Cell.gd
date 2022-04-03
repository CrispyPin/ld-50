extends Object


class_name Cell

enum Id {
	AIR,
	WALL,
	STONE,
	DIRT,
	WATER,
	SAND,
	FISH,
	KELP,
	TREE_1,
	TREE_2,
	FLOWER_1,
}

func kill(cells, x, y):
	cells.set_cell_id(x,y,Id.AIR)

func is_plant(id) -> bool:
	return id in [
		Id.TREE_1,
		Id.TREE_2,
		Id.FLOWER_1,
	]

func is_ground(id) -> bool:
	return id in [
		Id.WALL,
		Id.STONE,
		Id.SAND,
		Id.DIRT,
	]

func has_nearby(cells, x: int, y: int, id) -> bool:
	for dx in range(-1,2):
		for dy in range(-1,2):
			if cells.get_cell(x + dx, y + dy).getId() == id:
				return true
	return false

func is_in_water(cells, x, y) -> bool:
	return has_nearby(cells, x, y, Id.WATER)

func draw():
	return Color(0,0,0,1)

func getId():
	return Id.AIR

func update(_cells, _light, _x: int, _y: int):
	pass

