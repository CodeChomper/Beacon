extends Node2D


func _ready() -> void:
	$PingContainer.add_to_group("ping_container")
	var player: Node = $Player
	var exit_zone: Node = $Exit
	exit_zone.exited.connect(GameManager.load_next_level)
	player.died.connect(_on_player_died)


func _on_player_died() -> void:
	await get_tree().create_timer(0.6).timeout
	GameManager.reload_current_level()
