extends Node2D

signal finished
var tutorial_first:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not self.tutorial_first:
		$Button.text = "시작하기"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	self.finished.emit()
