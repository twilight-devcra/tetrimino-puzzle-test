extends Node2D

@export var grid_width: int = 6
@export var grid_height: int = 6
@export var block_size: float = 80.0
var answer_grid: Array
var pieces: Array[DraggablePiece] = []

func make_answer() -> bool:
	# init answer grid
	self.answer_grid = []
	for x in range(self.grid_width):
		var row = []
		for y in range(self.grid_height):
			row.append(0)
		self.answer_grid.append(row)
		
	for piece in self.pieces:
		var coords = []
		for x in range(self.grid_width):
			for y in range(self.grid_height):
				var count = cell_neighbors(piece, x, y)
				if count >= 0:
					coords.append([[x, y], count])
		
		if len(coords) == 0:
			# no valid positions for this piece.
			return false			
		coords.shuffle()
		coords.sort_custom(func (a, b): return a[1] > b[1])
		var picked_coords = coords[0][0]
		
		for cell in piece.cells:
			self.answer_grid[cell.x + picked_coords[0]][cell.y + picked_coords[1]] = 1
		
	return true
				
				
func cell_neighbors(piece:DraggablePiece, x:int, y:int) -> int:
	var count = 0
	var offsets:Array[Vector2i] = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	for cell in piece.cells:
		if cell.x + x >= self.grid_width or cell.y + y >= self.grid_height:
			return -1
			
		if self.answer_grid[cell.x + x][cell.y + y] != 0:
			return -1
			
		for offset in offsets:
			var target_cell = Vector2i(cell.x + x + offset.x, cell.y + y + offset.y)
			if target_cell.x < 0 or target_cell.x >= self.grid_width:
				continue
			if target_cell.y < 0 or target_cell.y >= self.grid_width:
				continue
			if self.answer_grid[target_cell.x][target_cell.y] != 0:
				count += 1 
	return count

func init(grid_width:int, grid_height:int, block_size:float) -> void:
	self.grid_width = grid_width
	self.grid_height = grid_height
	self.block_size = block_size
	
func add_piece(points: Array[Vector2i]):
	var piece = $PieceSpawn.add_piece(points, self.block_size)
	piece.placed.connect(self.on_piece_placed)
	self.pieces.append(piece)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_piece(PackedVector2Array([Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)]))
	self.add_piece(PackedVector2Array([Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]))
	self.add_piece(PackedVector2Array([Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]))
	self.add_piece(PackedVector2Array([Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3)]))
	
	while not self.make_answer():
		pass
	
	$Grid.init(self.grid_width, self.grid_height, self.block_size, self.answer_grid)
	$Grid.completed.connect(self.on_grid_completed)
	

func on_piece_placed(piece:DraggablePiece) -> void:
	var cell = $Grid.placed_piece_cell(piece)
	if cell.x < 0:
		# invalid cell
		piece.position = piece.initial_position
	else:
		# valid cell
		piece.global_position = $Grid.cell_global_position(cell)
		
	$Grid.update_piece_position(piece, cell)
	piece.grid_cell_position = cell
	
func on_grid_completed() -> void:
	print('Complete!')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
