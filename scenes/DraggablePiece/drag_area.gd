extends Area2D

signal dragged
signal dropped
signal lifted
var is_lifted = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed:
		if self.is_lifted:
			self.is_lifted = false
			self.dropped.emit()
	if self.is_lifted and event is InputEventMouseMotion:
		self.dragged.emit(event.relative)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		self.lifted.emit()
		self.is_lifted = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
