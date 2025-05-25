class_name PaddleSparks
extends MeshInstance3D

@export var lifetime: float = 0.5
@export var base_scale: float = 0.1
@export var scale_curve: Curve
@export_range(12, 60) var framerate: int = 18
@export var push_force: float = 2
@export var gravity: float = 0.1

var velocity: Vector3

var frame_period: float
var timer: float
var normalized_progress: float


func _ready() -> void:
    frame_period = 1.0 / framerate
    scale = Vector3.ONE * base_scale

func _process(delta: float) -> void:
    timer += delta
    if timer > frame_period:
        timer -= frame_period
        update(frame_period)


func push(direction: Vector3):
    rotation = Vector3(randf() * TAU, randf() * TAU, randf() * TAU)
    velocity = direction.normalized() * push_force
    base_scale *= direction.length()

func update(delta: float):
    normalized_progress += delta / lifetime
    position += velocity * delta
    velocity.y += gravity
    scale = Vector3.ONE * base_scale * scale_curve.sample(normalized_progress)
    if normalized_progress > 1: queue_free()