extends Node2D

var color:Color
var size:float
var squares:Array[Rect2i]
@export var border_width:float = 3.0

func init(color:Color, size:float, squares:Array[Vector2i]) -> void:
	self.color = color
	self.size = size
	self.squares = []
	for square in squares:
		self.squares.append(Rect2i(square.x * self.size, square.y * self.size, self.size, self.size))
	
func _draw() -> void:
	for square in self.squares:
		self.draw_rect(square, self.color)
		self.draw_rect(square, self.color.darkened(0.2), false, self.border_width)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
