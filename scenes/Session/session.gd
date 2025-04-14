extends Node2D
class_name Session

@export var tutorial_time:float = 30.0
@export var actual_time:float = 300.0
@export var do_tutorial:bool = true
@export var piece_drop_chance:float = 0.0
@export var piece_drop_start_time:float = 0.0
@export var piece_num:int = 4

var score:int

var startscreen_factory = preload("res://scenes/StartScreen/StartScreen.tscn")
var standby_factory = preload("res://scenes/Standby/Standby.tscn")
var round_factory = preload("res://scenes/SingleRound/SingleRound.tscn")
var final_results_factory = preload("res://scenes/FinalResult/FinalResult.tscn")
var data:SessionData

func init(tutorial_time:float, actual_time:float, do_tutorial:bool, piece_drop_chance:float, piece_num:int, piece_drop_start_time:float) -> void:
	self.tutorial_time = tutorial_time
	self.actual_time = actual_time
	self.do_tutorial = do_tutorial
	self.piece_drop_chance = piece_drop_chance
	self.piece_drop_start_time = piece_drop_start_time
	self.piece_num = piece_num
	
func standby(header:String) -> void:
	var standby_scene = standby_factory.instantiate()
	standby_scene.init(header)
	self.add_child(standby_scene)
	
	await standby_scene.finished
	self.remove_child(standby_scene)
	standby_scene.queue_free()
	
func round(time:float, is_tutorial:bool) -> void:
	self.data.start_round(is_tutorial)
	var single_round = round_factory.instantiate()
	single_round.init(time, self.piece_num, self.piece_drop_chance, self.piece_drop_start_time, is_tutorial)
	single_round.problem_solved.connect(self.on_problem_solved)
	self.add_child(single_round)
	
	self.score = await single_round.round_ended
	self.remove_child(single_round)
	single_round.queue_free()
	self.data.end_round()
	
func final_results() -> void:
	var result_screen = final_results_factory.instantiate()
	result_screen.init(self.score)
	self.add_child(result_screen)
	
	await result_screen.finished
	self.remove_child(result_screen)
	result_screen.queue_free()
	
func startscreen() -> void:
	var start_screen = startscreen_factory.instantiate()
	start_screen.tutorial_first = self.do_tutorial
	self.add_child(start_screen)
	
	await start_screen.finished
	self.remove_child(start_screen)
	start_screen.queue_free()
	
func start_tutorial() -> void:
	await self.standby('연습')
	await self.round(self.tutorial_time, true)
	
func start_actual() -> void:
	await self.standby('진짜 시작')
	await self.round(self.actual_time, false)
	
func on_problem_solved() -> void:
	self.data.problem_solved()

func _ready() -> void:
	await self.startscreen()
	
	self.data = SessionData.new(self.tutorial_time, self.actual_time, self.piece_drop_chance, self.piece_drop_start_time)
	
	if self.do_tutorial:
		await self.start_tutorial()
	await self.start_actual()
	self.data.export()
	await self.final_results()
	
	var options_scene = load("res://scenes/Settings/Settings.tscn").instantiate()
	self.get_tree().root.add_child(options_scene)
	self.get_node('/root/Session').queue_free()
