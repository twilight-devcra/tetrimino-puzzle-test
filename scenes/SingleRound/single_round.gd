extends Node2D

@export var timer:float = 30.0
var score:int = 0
var is_tutorial:bool
var drop_chance:float
var drop_start_time:float

signal round_ended
signal problem_solved

func init(timer:float, piece_num:int, drop_chance:float, drop_start_time:float, is_tutorial:bool=false) -> void:
	self.timer = timer
	self.is_tutorial = is_tutorial
	self.drop_chance = drop_chance
	self.drop_start_time = drop_start_time
	$ProblemGenerator.piece_num = piece_num

func _ready() -> void:
	if not self.is_tutorial:
		# don't drop pieces during the tutorial.
		if self.drop_start_time > 0:
			$PieceDropTimer.start(drop_start_time)
		else:
			$ProblemGenerator.drop_chance = drop_chance
	$TimerBar.start_timer(self.timer)
	if self.is_tutorial:
		$ProblemGenerator.show_tutorial()


func _on_problem_generator_solved() -> void:
	self.problem_solved.emit()
	self.score += 1
	$Score.text = '점수: ' + str(self.score)


func _on_timer_timeout() -> void:
	self.round_ended.emit(self.score)


func _on_piece_drop_timer_timeout() -> void:
	$ProblemGenerator.drop_chance = self.drop_chance
