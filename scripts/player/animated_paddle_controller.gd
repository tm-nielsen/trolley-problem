extends PaddleController

@export var tilt_angle := Vector2(1.0, 0.5)
@export var flip: bool
@export var spark_spawn_node: Node3D
@export var sparks_prefab: PackedScene


func _ready() -> void:
    pushed.connect(
        func(direction): spawn_sparks(-get_parent().global_basis.z * direction)
    )
    jumped.connect(
        func(): spawn_sparks(global_basis.x * (-1 if flip else 1))
    )

func _process(_delta: float) -> void:
    update_proxies()
    _update_rotation()
    process_input_movements()


func _update_rotation() -> void:
    rotation = get_target_rotation()

func get_target_rotation() -> Vector3:
    return Vector3(
        0,
        get_axis(paddle_forward, paddle_back, tilt_angle.x),
        get_axis(paddle_down, paddle_up, tilt_angle.y)
    ) * (-1 if flip else 1)

func get_axis(
    negative_key: ActionProxy,
    positive_key: ActionProxy,
    angle: float
) -> float:
    return (
        positive_key.pressed_value
        - negative_key.pressed_value
    ) * angle


func spawn_sparks(direction: Vector3):
    var sparks: PaddleSparks = sparks_prefab.instantiate()
    get_viewport().add_child(sparks)
    sparks.global_position = spark_spawn_node.global_position
    sparks.push(direction)