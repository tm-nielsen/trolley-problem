class_name CameraViewGrid
extends GridContainer

const VIEW_COUNT: int = 6

@export var camera_view_prefab: PackedScene
@export var camera_positions_parent: Node

var cameras: Array[TrackingCamera] = []


func _ready() -> void:
    for i in VIEW_COUNT:
        var view_instance: CameraView = camera_view_prefab.instantiate()
        add_child(view_instance)
        initialize_view(view_instance, i)
        cameras.append(view_instance.camera)

func initialize_view(view: CameraView, index: int) -> void:
    view.initialize(
        get_camera_position(index)
    )

func get_camera_position(index: int) -> Vector3:
    return camera_positions_parent.get_child(index).global_position
