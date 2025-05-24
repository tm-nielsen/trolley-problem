extends PaddleController

@export var tilt_angle := Vector2(1.0, 0.5)
@export var flip: bool


func _process(delta: float) -> void:
    super(delta)
    _update_rotation()


func _update_rotation() -> void:
    rotation = get_target_rotation()

func get_target_rotation() -> Vector3:
    return Vector3(
        0,
        get_axis(paddle_forward, paddle_back, tilt_angle.x),
        get_axis(paddle_down, paddle_up, tilt_angle.y)
    ) * (-1 if flip else 1)

func get_axis(
    negative_key: KeyProxy,
    positive_key: KeyProxy,
    angle: float
) -> float:
    return (
        positive_key.pressed_value
        - negative_key.pressed_value
    ) * angle