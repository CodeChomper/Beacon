extends Control


func _ready() -> void:
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)


func _on_restart_pressed() -> void:
	GameManager.start_game()


func _on_quit_pressed() -> void:
	get_tree().quit()
