@tool
extends Node2D
class_name Grid

@export var width: int = 6:
	set(x):
		width = x
		self.queue_redraw()
	
@export var height: int = 6:
	set(x):
		height = x
		self.queue_redraw()
		
@export var cell_size: int = 80:
	set(x):
		cell_size = x
		self.queue_redraw()
		
@export var border_color: Color = Color.WHITE_SMOKE:
	set(x):
		border_color = x
		self.queue_redraw()
		
@export var answer_color: Color = Color.GHOST_WHITE
		
@export var border_width: float = 3.0:
	set(x):
		border_width = x
		self.queue_redraw()

var answer_grid: Array		
var filled_grid: Array

signal completed

func init(width:int, height:int, cell_size:int, answer:Array) -> void:
	self.width = width
	self.height = height
	self.cell_size = cell_size
	self.answer_grid = answer
	self.filled_grid = []
	for x in self.answer_grid:
		var row = []
		for y in x:
			row.append(0)
		self.filled_grid.append(row)
	
func cell_global_position(cell:Vector2) -> Vector2:
	return self.global_position + cell * self.cell_size
	
func placed_piece_cell(piece:DraggablePiece) -> Vector2i:
	var offset:Vector2 = piece.global_position - self.global_position
	var cell:Vector2 = round(offset / float(self.cell_size))
	
	if not (0 <= cell.x and cell.x <= self.width - piece.piece_size.x) \
	or not (0 <= cell.y and cell.y <= self.height - piece.piece_size.y):
		# off the grid
		return Vector2i(-1, -1)
	
	for square in piece.cells:
		if self.filled_grid[cell.x + square.x][cell.y + square.y] != 0 and self.filled_grid[cell.x + square.x][cell.y + square.y] != piece.id:
			# already filled by a different piece
			return Vector2i(-1, -1)
	
	return cell
	
func update_piece_position(piece:DraggablePiece, new_cell:Vector2i) -> void:
	if piece.grid_cell_position.x >= 0:
		# it was originally on the grid.
		# remove it.
		for square in piece.cells:
			self.filled_grid[piece.grid_cell_position.x + square.x][piece.grid_cell_position.y + square.y] = 0
			
	if new_cell.x >= 0:
		# it was placed on the grid.
		for square in piece.cells:
			self.filled_grid[new_cell.x + square.x][new_cell.y + square.y] = piece.id
			
	if check_answer():
		self.completed.emit()
		

func check_answer() -> bool:
	for x in range(len(self.answer_grid)):
		for y in range(len(self.answer_grid[x])):
			var a = self.answer_grid[x][y] != 0
			var b = self.filled_grid[x][y] != 0
			if a != b:
				return false
	return true

func draw_grid() -> void:
	for x in range(self.width):
		for y in range(self.height):
			var rect = Rect2(x * self.cell_size, y * self.cell_size, self.cell_size, self.cell_size)
			if not Engine.is_editor_hint() and self.answer_grid[x][y] != 0:
				# fill the square in.
				self.draw_rect(rect, self.answer_color)
			self.draw_rect(rect, self.border_color, false, self.border_width)
				
	
func _draw() -> void:
	self.draw_grid()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
