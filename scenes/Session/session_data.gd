extends Resource
class_name SessionData

var start_timestamp:float
var tutorial_time:float
var actual_time:float
var drop_chance:float
var drop_start_time:float
var rounds:Array
var current_round:Dictionary

func timestamp() -> float:
	return Time.get_unix_time_from_system()

func _init(tutorial_time:float, actual_time:float, drop_chance:float, drop_start_time:float) -> void:
	self.start_timestamp = self.timestamp()
	self.tutorial_time = tutorial_time
	self.actual_time = actual_time
	self.drop_chance = drop_chance
	self.drop_start_time = drop_start_time
	self.rounds = []
	
func start_round(is_tutorial:bool) -> void:
	self.current_round = {
		'start_time': self.timestamp() - self.start_timestamp,
		'is_tutorial': is_tutorial,
		'timeline': []
	}
	
func problem_solved() -> void:
	self.current_round['timeline'].append({
		'type': 'solved',
		'timestamp': self.timestamp() - self.start_timestamp
	})
	
func end_round() -> void:
	self.rounds.append(self.current_round)
	
func export() -> void:
	var data = {
		'start_timestamp': self.start_timestamp,
		'params': {
			'tutorial_time': self.tutorial_time,
			'actual_time': self.actual_time,
			'drop_chance': self.drop_chance,
			'drop_start_time': self.drop_start_time
		},
		'rounds': self.rounds
	}
	var file_str = '%s.json' % Time.get_datetime_string_from_system().replace(':', '')
	var file = FileAccess.open('user://%s' % file_str, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, '\t'))
