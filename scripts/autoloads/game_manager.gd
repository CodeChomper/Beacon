extends Node

const LEVELS: Array[String] = [
	"res://levels/level_01.tscn",
	"res://levels/level_02.tscn",
	"res://levels/level_03.tscn",
	"res://levels/level_04.tscn",
	"res://levels/level_05.tscn",
]

var current_level_index: int = 0


func start_game() -> void:
	current_level_index = 0
	get_tree().change_scene_to_file(LEVELS[current_level_index])


func load_next_level() -> void:
	current_level_index += 1
	if current_level_index >= LEVELS.size():
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
	else:
		get_tree().change_scene_to_file(LEVELS[current_level_index])


func reload_current_level() -> void:
	get_tree().change_scene_to_file(LEVELS[current_level_index])
