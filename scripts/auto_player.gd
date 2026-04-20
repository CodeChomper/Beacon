extends CharacterBody2D

const SPEED: float = 120.0
const PING_SCENE: PackedScene = preload("res://scenes/ping.tscn")
const PING_MIN: float = 1.0
const PING_MAX: float = 3.0
const TARGET_THRESHOLD: float = 20.0
const STUCK_TIME: float = 0.5
const STUCK_DIST_SQ: float = 4.0  # 2px movement threshold squared

var _target: Vector2
var _stuck_timer: float = 0.0
var _last_position: Vector2

@onready var ping_timer: Timer = $PingTimer


func _ready() -> void:
	add_to_group("player")
	_pick_target()
	_schedule_ping()
	_last_position = global_position


func _physics_process(delta: float) -> void:
	var dir := _target - global_position
	if dir.length() < TARGET_THRESHOLD:
		_pick_target()
	velocity = dir.normalized() * SPEED
	move_and_slide()

	if global_position.distance_squared_to(_last_position) < STUCK_DIST_SQ:
		_stuck_timer += delta
		if _stuck_timer >= STUCK_TIME:
			_pick_target()
			_stuck_timer = 0.0
	else:
		_stuck_timer = 0.0
		_last_position = global_position


func _pick_target() -> void:
	var rect := get_viewport_rect()
	_target = Vector2(
		randf_range(60.0, rect.size.x - 60.0),
		randf_range(60.0, rect.size.y - 60.0)
	)


func _schedule_ping() -> void:
	ping_timer.wait_time = randf_range(PING_MIN, PING_MAX)
	ping_timer.start()


func _on_ping_timer_timeout() -> void:
	var ping: Node2D = PING_SCENE.instantiate()
	#ping.play_sound = false
	get_parent().add_child(ping)
	ping.global_position = global_position
	_schedule_ping()

func die() -> void:
	#set_physics_process(false)
	#set_process_input(false)
	emit_signal("died")
	#$AudioStreamPlayer2D.play(0.0)
