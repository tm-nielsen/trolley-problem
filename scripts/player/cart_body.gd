class_name CartBody
extends CharacterBody3D

@export var push_force: float = 10
@export var up_force: float = 5
@export_range(0, 1) var friction: float = 0.1

@export_subgroup("paddles")
@export var right_paddle: PaddleController
@export var left_paddle: PaddleController


func _ready() -> void:
    right_paddle.pushed_forward.connect(
        apply_forward_push
    )

func _physics_process(delta: float) -> void:
    velocity += get_gravity() * delta
    velocity *= max(1 - friction * delta * 60, 0)
    move_and_slide()

func apply_forward_push():
    velocity += basis.z * push_force
