@tool
extends Node2D

var piece_factory
var colors: Array[Color] = [
	Color.AQUA,
	Color.AQUAMARINE,
	Color.BLUE_VIOLET,
	Color.BROWN,
	Color.CHARTREUSE,
	Color.DARK_ORANGE,
	Color.WEB_GREEN
]
var place_retries:int = 50

var next_piece_id:int = 1
var pieces:Array[DraggablePiece] = []

@export var width:float = 500:
	set(x):
		width = x
		self.queue_redraw()
		
@export var height:float = 500:
	set(x):
		height = x
		self.queue_redraw()
		
func place_piece(piece:DraggablePiece) -> void:
	var piece_size = piece.piece_size * piece.cell_size
	var x = 0.0
	var y = 0.0
	for try in range(self.place_retries):
		x = randf_range(0, self.width - piece_size.x)
		y = randf_range(0, self.height - piece_size.y)
		var positioned_box = Rect2(Vector2(x, y), piece_size)
		
		# check for overlaps.
		var overlapped = false
		for other_peice in self.pieces:
			var other_box = Rect2(other_peice.initial_position, other_peice.piece_size * other_peice.cell_size)
			if other_box.intersects(positioned_box):
				overlapped = true
				break
		
		if not overlapped:
			break
			
	piece.initial_position = Vector2(x, y)

func add_piece(block_coords:Array[Vector2i], block_size:float, drop_chance:float) -> DraggablePiece:
	var piece:DraggablePiece = self.piece_factory.instantiate()
	piece.init(self.next_piece_id, self.colors.pop_front(), block_size, block_coords, drop_chance)
	self.next_piece_id += 1
	self.place_piece(piece)
	self.pieces.append(piece)
	piece.lifted.connect(self.on_piece_lifted)
	self.add_child(piece)
	return piece
	
func on_piece_lifted(piece:DraggablePiece) -> void:
	self.move_child(piece, -1)
	
func _init() -> void:
	self.piece_factory = load("res://scenes/DraggablePiece/DraggablePiece.tscn")
	self.colors.shuffle()
	

func _draw() -> void:
	if Engine.is_editor_hint():
		self.draw_rect(Rect2(0, 0, self.width, self.height), Color.GREEN_YELLOW)
		
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
