extends Node2D

const EXPAND_DURATION: float = 1.2
const MAX_RADIUS: float = 260.0
const MAX_TEXTURE_SCALE: float = 3.5

@onready var ping_light: PointLight2D = $PingLight
@onready var ring_area: Area2D = $RingArea
@onready var collision_shape: CollisionShape2D = $RingArea/CollisionShape2D
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	ring_area.body_entered.connect(_on_ring_area_body_entered)
	_start_expand()


func _start_expand() -> void:
	sound.play(0.0)
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(ping_light, "texture_scale", MAX_TEXTURE_SCALE, EXPAND_DURATION)
	tween.tween_property(ping_light, "energy", 0.0, EXPAND_DURATION)
	tween.tween_method(_set_collision_radius, 10.0, MAX_RADIUS, EXPAND_DURATION)
	tween.chain().tween_callback(queue_free)


func _set_collision_radius(r: float) -> void:
	(collision_shape.shape as CircleShape2D).radius = r


func _on_ring_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.alert(global_position)
