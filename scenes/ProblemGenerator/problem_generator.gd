extends Node2D

var problem_factory = preload("res://scenes/Problem/Problem.tscn")

@export var grid_width:int = 6
@export var grid_height:int = 6
@export var piece_num:int = 4
@export var block_size:float = 60.0

var current_problem:Problem

func new_question() -> void:
	var problem:Problem = problem_factory.instantiate()
	problem.init(self.grid_width, self.grid_height, self.block_size, self.piece_num)
	problem.completed.connect(self.on_question_completed)
	self.current_problem = problem
	self.add_child(problem)

func on_question_completed() -> void:
	if current_problem != null:
		current_problem.queue_free()
		
	self.new_question()

func _ready() -> void:
	self.new_question()
