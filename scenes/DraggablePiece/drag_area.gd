extends Area2D

signal dragged
signal dropped
signal lifted
var is_lifted:bool = false
var drop_chance:float = 0.0
var dropped_times:int = 0

@export var max_dropped_times:int = 3

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
		self.get_viewport().set_input_as_handled()
		
		if self.dropped_times < self.max_dropped_times and randf() < self.drop_chance:
			$Timer.start(randf() * 0.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	self.dropped_times += 1
	self.is_lifted = false
	self.dropped.emit()
