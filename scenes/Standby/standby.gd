extends Node2D

var header:String
var time:int

signal finished

func init(header:String, time:int=5) -> void:
	self.header = header
	self.time = time
	
func update_countdown() -> void:
	$Countdown.text = str(self.time)
	
func _ready() -> void:
	$Header.text = self.header
	self.update_countdown()
	$Timer.start()

func _on_timer_timeout() -> void:
	self.time -= 1
	
	if self.time == 0:
		self.finished.emit()
	else:
		self.update_countdown()
	
