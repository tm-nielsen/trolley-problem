extends Node3D

@export var apply_random_offset: bool = true
@export var animator: AnimationPlayer

@export_subgroup("rotation", "rotation")
@export var rotation_enabled: bool = false
@export var rotation_node: Node3D
@export var rotation_period: float = 1.0
@export var rotation_interpolation := Tween.TRANS_CUBIC


func _ready():
    if rotation_enabled: start_rotation_tween()
    animator.current_animation.length()
    if apply_random_offset: animator.advance(
        randf() * animator.current_animation.length()
    )

func start_rotation_tween():
    var rotate_tween = TweenHelpers.build_tween(
        self, 0, Tween.EASE_IN_OUT, rotation_interpolation
    ).set_loops()
    rotate_tween.tween_property(
        rotation_node, "rotation:z", TAU, rotation_period
    )
    rotate_tween.tween_callback(
        func(): rotation_node.rotation.z = 0
    )
    if apply_random_offset:
        rotate_tween.custom_step(randf() * rotation_period)