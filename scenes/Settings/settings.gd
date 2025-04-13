extends Node2D

var session_scene:Session

func _ready() -> void:
	self.session_scene = load("res://scenes/Session/Session.tscn").instantiate()


func _on_button_pressed() -> void:
	self.session_scene.init(
		$TutorialTime/SpinBox.value,
		$ActualTime/SpinBox.value,
		$TutorialExist/CheckBox.button_pressed,
		$MouseUpChance/SpinBox.value / 100.0,
		$PieceNum/SpinBox.value
	)

	self.get_tree().root.add_child(self.session_scene)
	self.get_node('/root/Settings').queue_free()
