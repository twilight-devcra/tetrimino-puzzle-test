extends Node2D

var grid:Grid
var piece_factory = load("res://scenes/DraggablePiece/DraggablePiece.tscn")

func create_piece(color:Color, segments:Array[Vector2i]) -> void:
	var piece:DraggablePiece = piece_factory.instantiate()
	piece.init(color, 60, segments)
	piece.placed.connect(self.on_piece_placed)
	self.add_child(piece)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.grid = load("res://scenes/Grid/grid.tscn").instantiate()
	self.grid.position = Vector2(400, 100)
	self.grid.init(6, 5, 60)
	self.add_child(self.grid)
	
	self.create_piece(Color.RED, [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(2, 0)])
	self.create_piece(Color.GREEN, [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)])
	self.create_piece(Color.BLUE, [Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3)])
	
	
func on_piece_placed(piece:DraggablePiece) -> void:
	piece.position = self.grid.snap_to_grid(piece.position, piece.size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
