extends Node2D

@export var timer:float = 30.0
var score:int = 0
var is_tutorial:bool

signal round_ended

func init(timer:float, is_tutorial:bool=false) -> void:
	self.timer = timer
	self.is_tutorial = is_tutorial

func _ready() -> void:
	$TimerBar.start_timer(self.timer)
	if self.is_tutorial:
		$ProblemGenerator.show_tutorial()


func _on_problem_generator_solved() -> void:
	self.score += 1
	$Score.text = '점수: ' + str(self.score)


func _on_timer_timeout() -> void:
	self.round_ended.emit(self.score)
