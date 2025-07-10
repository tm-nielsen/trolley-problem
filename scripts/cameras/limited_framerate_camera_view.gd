class_name LimitedFrameRateCameraView
extends CameraView

@export var fps: int = 12


func initialize(camera_position: Vector3, title: String):
    super(camera_position, title)
    var update_tween := create_tween()
    update_tween.set_loops()
    update_tween.tween_callback(update_view)
    update_tween.tween_interval(1.0 / fps)

func update_view():
    viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
