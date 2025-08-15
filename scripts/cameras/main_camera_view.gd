class_name MainCameraView
extends CameraView

@export var view_grid: CameraViewGrid
@export var default_camera_index: int = 0
@export var fov_tween_scale: float = 1.2
@export var fov_tween_duration: float = 0.3

var fov_tween: Tween
var enabled: bool = false


func _ready():
    view_grid.initialize_view(self, default_camera_index)
    viewport.audio_listener_enable_3d = true

func _process(_delta: float) -> void:
    if !enabled: return
    for i in CameraViewGrid.VIEW_COUNT:
        if Input.is_action_just_pressed("camera %d" % (i + 1)):
            set_camera(view_grid.cameras[i])
            label.text = "Cam %d" % (i + 1)
            start_fov_tween()

func start_fov_tween():
    if fov_tween: fov_tween.kill()
    camera.fov = fov * fov_tween_scale
    fov_tween = TweenHelpers.build_tween(self)
    fov_tween.tween_property(
        camera, "fov", fov, fov_tween_duration
    )

func enable():
    enabled = true
