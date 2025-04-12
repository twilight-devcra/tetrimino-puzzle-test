extends Node2D

var problem_factory = preload("res://scenes/Problem/Problem.tscn")

@export var grid_width:int = 6
@export var grid_height:int = 6
@export var piece_num:int = 4
@export var block_size:float = 60.0
var is_tutorial:bool = false

var current_problem:Problem

signal solved

func show_tutorial() -> void:
	$Label.visible = true
	$Label2.visible = true

func new_question() -> void:
	var problem:Problem = problem_factory.instantiate()
	problem.init(self.grid_width, self.grid_height, self.block_size, self.piece_num)
	problem.completed.connect(self.on_question_completed)
	self.current_problem = problem
	self.add_child(problem)
	
func complete_anim() -> void:
	var material = load('res://scenes/DraggablePiece/DraggablePiece.tres')
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/amount", 1.0, 0.1)
	tween.tween_property(material, "shader_parameter/amount", 0.0, 0.1)
	tween.tween_property(material, "shader_parameter/amount", 1.0, 0.1)
	tween.tween_property(material, "shader_parameter/amount", 0.0, 0.1)
	
	await tween.finished

func on_question_completed() -> void:
	self.solved.emit()
	await self.complete_anim()
	if current_problem != null:
		current_problem.queue_free()
		
	self.new_question()

func _ready() -> void:
	self.new_question()
