extends Node2D
class_name DraggablePiece

signal placed

var size: Vector2

func calculate_size(squares:Array[Vector2i], size:float) -> Vector2i:
	var max_size = Vector2i(0,0)
	for square in squares:
		max_size = max_size.max(square)
		
	return (max_size + Vector2i(1, 1)) * size

func collision_box(squares:Array[Vector2i], size:float) -> RectangleShape2D:
	var box = RectangleShape2D.new()
	var max_size = Vector2i(0,0)
	for square in squares:
		max_size = max_size.max(square)
		
	box.size = (max_size + Vector2i(1,1)) * size
	return box

func init(color:Color, size:float, squares:Array[Vector2i]) -> void:
	$Sprite.init(color, size, squares)
	self.size = self.calculate_size(squares, size)
	var col_box = RectangleShape2D.new()
	col_box.size = self.size
	$DragArea/CollisionShape2D.shape = col_box
	$DragArea/CollisionShape2D.position = self.size / 2
	
	print($DragArea/CollisionShape2D.shape.size)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DragArea.dragged.connect(self.on_dragged)
	$DragArea.dropped.connect(self.on_dropped)
	

func on_dragged(relative) -> void:
	self.position += relative
	self.position = self.position.clamp(Vector2(0,0), get_viewport_rect().size - self.size)
	
func on_dropped() -> void:
	self.placed.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
