class_name MainCameraView
extends CameraView

@export var view_grid: CameraViewGrid
@export var default_camera_index: int = 0

func _ready():
    view_grid.initialize_view(self, default_camera_index)

func _process(_delta: float) -> void:
    for i in CameraViewGrid.VIEW_COUNT:
        if Input.is_action_just_pressed("camera %d" % (i + 1)):
            set_camera(view_grid.cameras[i])
            label.text = "Cam %d" % (i + 1)