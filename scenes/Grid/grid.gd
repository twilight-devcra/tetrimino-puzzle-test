extends Node2D
class_name Grid

var width: int
var height: int
var cell_size: int
@export var border_color: Color = Color.WHITE_SMOKE
@export var border_width: float = 3.0

func init(width:int, height:int, cell_size:int) -> void:
	self.width = width
	self.height = height
	self.cell_size = cell_size
	
func snap_to_grid(pos:Vector2, piece_size:Vector2) -> Vector2:
	if self.is_inside_grid(pos, piece_size):
		var offset = pos - self.global_position
		var cell_offset = round(offset / float(self.cell_size))
		cell_offset = clamp(cell_offset, Vector2(0, 0), Vector2(self.width, self.height))
		return self.global_position + cell_offset * self.cell_size
	else:
		return pos
	
func is_inside_grid(pos:Vector2, size:Vector2) -> bool:
	var margin = Vector2(self.cell_size / 2.0, self.cell_size / 2.0)
	
	var boundaries = Rect2(self.global_position - margin, Vector2((width + 1) * self.cell_size, (height + 1) * self.cell_size))
	var shape = Rect2(pos, size)
	print(boundaries, shape)
	return boundaries.encloses(shape)
	
func _draw() -> void:
	for x in range(self.width):
		for y in range(self.height):
			var rect = Rect2(x * self.cell_size, y * self.cell_size, self.cell_size, self.cell_size)
			self.draw_rect(rect, self.border_color, false, self.border_width)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
