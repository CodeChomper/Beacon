extends CharacterBody2D

enum State { IDLE, ALERTED, WALKING_TO_PING, WAITING, RETURNING }

const WALK_SPEED: float = 60.0
const WAIT_DURATION: float = 2.5
const ARRIVAL_THRESHOLD: float = 8.0
const WALK_TIMEOUT: float = 6.0

var state: State = State.IDLE
var home_position: Vector2
var ping_origin: Vector2
var wait_timer: float = 0.0
var walk_timer: float = 0.0
var player: CharacterBody2D

@onready var enemy_light: PointLight2D = $EnemyLight
@onready var player_detect: Area2D = $PlayerDetect


func _ready() -> void:
	await get_tree().process_frame
	home_position = global_position
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")
	player_detect.body_entered.connect(_on_player_detect_body_entered)

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			pass
		State.ALERTED:
			state = State.WALKING_TO_PING
		State.WALKING_TO_PING:
			if player: ping_origin = player.global_position
			walk_timer += delta
			if walk_timer >= WALK_TIMEOUT:
				state = State.WAITING
				walk_timer = 0
			_walk_toward(ping_origin, delta)
			if global_position.distance_to(ping_origin) < ARRIVAL_THRESHOLD:
				velocity = Vector2.ZERO
				state = State.WAITING
				wait_timer = WAIT_DURATION
				_fade_light(0.2, WAIT_DURATION)
		State.WAITING:
			wait_timer -= delta
			if wait_timer <= 0.0:
				state = State.RETURNING
		State.RETURNING:
			_walk_toward(home_position, delta)
			if global_position.distance_to(home_position) < ARRIVAL_THRESHOLD:
				global_position = home_position
				velocity = Vector2.ZERO
				state = State.IDLE
				enemy_light.energy = 0.06


func alert(origin: Vector2) -> void:
	if state == State.IDLE or state == State.WAITING or state == State.RETURNING:
		ping_origin = origin
		state = State.ALERTED
		_flash_light()


func _walk_toward(target: Vector2, _delta: float) -> void:
	var direction: Vector2 = (target - global_position).normalized()
	velocity = direction * WALK_SPEED
	move_and_slide()


func _flash_light() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(enemy_light, "energy", 0.8, 0.15)


func _fade_light(to_energy: float, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(enemy_light, "energy", to_energy, duration)


func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()
