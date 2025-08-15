class_name LimitedFrameRateCameraView
extends CameraView

@export var target_fps: float = 12
@export var update_threshold: int = 50
@export var minimum_fps: float = 0.25

var last_frame_time: float
var time_since_last_update: float


func initialize(camera_position: Vector3, title: String):
    super(camera_position, title)
    update_view()
    GlobalSignalBus.item_collected.connect(
        func(_item): update_view()
    )

    time_since_last_update = randf() / minimum_fps

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
    if (
        1 / last_frame_time < update_threshold &&
        time_since_last_update < 1.0 / minimum_fps
     ): return
    update_view()

func update_view():
    viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
    time_since_last_update = 0


func _process(delta):
    last_frame_time = delta
    time_since_last_update += delta