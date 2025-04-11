extends Node2D
class_name DraggablePiece

signal placed
signal lifted

var id: int
var cell_size: float
var piece_size: Vector2i
var cells: Array[Vector2i]
var initial_position: Vector2 = Vector2(0,0)
var grid_cell_position: Vector2i = Vector2i(-1,-1)

func calculate_size(squares:Array[Vector2i], size:float) -> Vector2i:
	var max_size = Vector2i(0,0)
	for square in squares:
		max_size = max_size.max(square)
		
	#return (max_size + Vector2i(1, 1)) * size
	return max_size + Vector2i(1, 1)

func collision_box(squares:Array[Vector2i], size:float) -> RectangleShape2D:
	var box = RectangleShape2D.new()
	var max_size = Vector2i(0,0)
	for square in squares:
		max_size = max_size.max(square)
		
	box.size = (max_size + Vector2i(1,1)) * size
	return box

func init(id:int, color:Color, size:float, squares:Array[Vector2i]) -> void:
	$Sprite.init(color, size, squares)
	self.id = id
	self.cells = squares
	self.cell_size = size
	self.piece_size = self.calculate_size(squares, size)
	var col_box = RectangleShape2D.new()
	col_box.size = self.piece_size * size
	$DragArea/CollisionShape2D.shape = col_box
	$DragArea/CollisionShape2D.position = self.piece_size * size / 2
	
	print($DragArea/CollisionShape2D.shape.size)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = self.initial_position
	$DragArea.dragged.connect(self.on_dragged)
	$DragArea.dropped.connect(self.on_dropped)
	$DragArea.lifted.connect(self.on_lifted)
	

func on_lifted() -> void:
	self.lifted.emit(self)
	

func on_dragged(relative) -> void:
	self.global_position += relative
	self.global_position = self.global_position.clamp(Vector2(0,0), get_viewport_rect().size - self.piece_size * self.cell_size)
	
func on_dropped() -> void:
	self.placed.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
