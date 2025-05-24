class_name CartBody
extends CharacterBody3D

@export var push_force: float = 4
@export var turn_force: float = 4
@export var jump_force: float = 2
@export_range(0, 1) var friction: float = 0.1
@export_range(0, 1) var angular_friction: float = 0.1

@export_subgroup("paddles")
@export var right_paddle: PaddleController
@export var left_paddle: PaddleController

var angular_velocity: float


func _ready() -> void:
    right_paddle.pushed.connect(apply_push.bind(-1))
    left_paddle.pushed.connect(apply_push.bind(1))
    right_paddle.jumped.connect(apply_jump.bind(left_paddle))
    left_paddle.jumped.connect(apply_jump.bind(right_paddle))

func _physics_process(delta: float) -> void:
    velocity += get_gravity() * delta
    if is_on_floor():
        velocity *= get_friction_multiplier(friction, delta)
        angular_velocity *= get_friction_multiplier(angular_friction, delta)
    rotate_y(angular_velocity)
    move_and_slide()


func apply_push(push_scale: float, turn_direction: float):
    velocity += basis.z * push_force * push_scale
    angular_velocity += turn_force / 100 * push_scale * turn_direction

func apply_jump(opposite_paddle: PaddleController):
    if is_on_floor(): velocity.y += jump_force
    elif opposite_paddle.was_jump_flicked(): velocity.y += jump_force * 4



func get_friction_multiplier(f: float, delta: float) -> float:
    return max(1 - f * delta * Engine.physics_ticks_per_second, 0);
