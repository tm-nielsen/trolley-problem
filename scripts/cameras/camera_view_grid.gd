extends GridContainer

const VIEW_COUNT: int = 6

@export var camera_view_prefab: PackedScene
@export var camera_positions_parent: Node

func _ready() -> void:
    for i in VIEW_COUNT:
        var view_instance: CameraView = camera_view_prefab.instantiate()
        add_child(view_instance)
        view_instance.initialize_camera(
            camera_positions_parent.get_child(i).global_position
        )
