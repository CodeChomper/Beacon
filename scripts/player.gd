extends CharacterBody2D

signal died

const SPEED: float = 120.0
const PING_SCENE: PackedScene = preload("res://scenes/ping.tscn")

var can_ping: bool = true

@onready var player_light: PointLight2D = $PlayerLight
@onready var ping_timer: Timer = $PingCooldownTimer


func _ready() -> void:
	add_to_group("player")


func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * SPEED
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ping") and can_ping:
		_fire_ping()


func _fire_ping() -> void:
	can_ping = false
	ping_timer.start()
	var ping: Node2D = PING_SCENE.instantiate()
	var container := get_tree().get_first_node_in_group("ping_container")
	if container:
		container.add_child(ping)
	else:
		get_parent().add_child(ping)
	ping.global_position = global_position


func _on_ping_cooldown_timer_timeout() -> void:
	can_ping = true


func die() -> void:
	set_physics_process(false)
	set_process_input(false)
	emit_signal("died")
	$AudioStreamPlayer2D.play(0.0)
