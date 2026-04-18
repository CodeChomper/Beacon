extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/LevelLabel.text = "Level: " + str(GameManager.current_level_index + 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
