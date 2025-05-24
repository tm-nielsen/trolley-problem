class_name CartBody
extends RigidBody3D

@export var push_force: float = 10
@export var up_force: float = 5
@export var sync_multiplier: float = 2

@export var right_paddle: PaddleController
@export var left_paddle: PaddleController


func _ready() -> void:
    right_paddle.pushed_forward.connect(apply_forward_push)

func apply_forward_push():
    apply_impulse(basis.z * push_force)