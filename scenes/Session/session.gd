extends Node2D

@export var tutorial_time:float = 30.0
@export var actual_time:float = 300.0

var score:int

var standby_factory = preload("res://scenes/Standby/Standby.tscn")
var round_factory = preload("res://scenes/SingleRound/SingleRound.tscn")
var final_results_factory = preload("res://scenes/FinalResult/FinalResult.tscn")

func init(tutorial_time:float=30.0, actual_time:float=300.0) -> void:
	self.tutorial_time = tutorial_time
	self.actual_time = actual_time
	
func standby(header:String) -> void:
	var standby_scene = standby_factory.instantiate()
	standby_scene.init(header)
	self.add_child(standby_scene)
	
	await standby_scene.finished
	self.remove_child(standby_scene)
	standby_scene.queue_free()
	
func round(time:float, is_tutorial:bool) -> void:
	var single_round = round_factory.instantiate()
	single_round.init(time, is_tutorial)
	self.add_child(single_round)
	
	self.score = await single_round.round_ended
	self.remove_child(single_round)
	single_round.queue_free()
	
func final_results() -> void:
	var result_screen = final_results_factory.instantiate()
	result_screen.init(self.score)
	self.add_child(result_screen)
	
	await result_screen.finished
	self.remove_child(result_screen)
	result_screen.queue_free()
	
	
	
func start_tutorial() -> void:
	await self.standby('연습')
	await self.round(self.tutorial_time, true)
	
func start_actual() -> void:
	await self.standby('진짜 시작')
	await self.round(self.actual_time, false)

func _ready() -> void:
	await self.start_tutorial()
	await self.start_actual()
	await self.final_results()
