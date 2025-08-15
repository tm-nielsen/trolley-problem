class_name LimitedFrameRateCameraView
extends CameraView

@export var target_fps: float = 12
@export var update_threshold: int = 40

var last_frame_time: float


func initialize(camera_position: Vector3, title: String):
    super(camera_position, title)
    update_view()

    var delay_tween = create_tween()
    delay_tween.tween_interval(target_fps * randf() / target_fps)
    delay_tween.tween_callback(
        func():
        var update_tween := create_tween()
        update_tween.set_loops()
        update_tween.tween_callback(update_view_smooth)
        update_tween.tween_interval(1.0 / target_fps)
    )

func update_view_smooth():
    if 1 / last_frame_time < update_threshold: return
    update_view()

func update_view():
    viewport.render_target_update_mode = SubViewport.UPDATE_ONCE


func _process(delta):
    last_frame_time = delta