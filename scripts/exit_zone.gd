extends Area2D

signal exited


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_pulse_light()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("exited")


func _pulse_light() -> void:
	var exit_light: PointLight2D = $ExitLight
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(exit_light, "energy", 1.0, 0.8)
	tween.tween_property(exit_light, "energy", 0.3, 0.8)
