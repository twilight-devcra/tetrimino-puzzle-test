extends Resource
class_name Pieces

var four = [
	[[0, 0], [1, 0], [2, 0], [3, 0]],
	[[0, 0], [0, 1], [0, 2], [0, 3]],
	[[0,0], [1,0], [1,1], [0, 1]],
	[[0,0], [1, 0], [1,1], [2, 1]],
	[[1,0], [1,1], [0,1], [0,2]],
	[[0,0], [0,1], [1,1], [1,2]],
	[[1,0], [1,1], [0,1], [2,0]],
	[[0,0], [0,1], [0,2], [1,1]],
	[[0,0], [1,0], [2,0], [1,1]],
	[[1,0], [1,1], [0,1], [2,1]],
	[[1,0], [1,1], [0,1], [1,2]],
	[[0,0], [1,0], [2,0], [0,1]],
	[[0,0], [1,0], [2,0], [2,1]],
	[[0,0], [0,1], [0,2], [1,0]],
	[[0,0], [0,1], [0,2], [1,2]],
	[[2,0], [0,1], [1,1], [2,1]],
	[[0,0], [0,1], [1,1], [2,1]],
]

var three = [
	[[0,0], [0,1], [0,2]],
	[[0,0], [1,0], [2,0]],
	[[0,0], [1,0], [1,1]],
	[[0,0], [1,0], [0,1]],
	[[0,0], [0,1], [1,1]],
	[[0,1], [1,0], [1,1]],
]

func random_four() -> PackedVector2Array:
	var elem:Array = four.pick_random()
	return PackedVector2Array(elem.map(func(e): return Vector2i(e[0], e[1])))

func random_three() -> PackedVector2Array:
	var elem:Array = three.pick_random()
	return PackedVector2Array(elem.map(func(e): return Vector2i(e[0], e[1])))
