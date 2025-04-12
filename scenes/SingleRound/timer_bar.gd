@tool
extends Node2D

func start_timer(time: float, color:Color=Color.YELLOW) -> void:
	$ProgressBar.max_value = time
	$ProgressBar.get("theme_override_styles/fill").bg_color = color
	self.visible = true
	$Timer.start(time)

func _ready() -> void:
	if Engine.is_editor_hint():
		self.visible = true
		$ProgressBar.max_value = 300
		$ProgressBar.value = 150
		$ProgressBar.get("theme_override_styles/fill").bg_color = Color.YELLOW
	else:
		self.visible = false

func _process(delta: float) -> void:
	if (self.visible and not Engine.is_editor_hint()):
		$ProgressBar.value = $Timer.time_left

func _on_timer_timeout() -> void:
	self.visible = false # Replace with function body.
