extends FontScaledLabel

@export var starting_time: float = 30
@export var collection_bonus: float = 30

@export_subgroup("tween_effects")
@export var second_scale: float = 0.8
@export var ten_second_scale: float = 0.6
@export var second_scale_duration: float = 0.1
@export var ten_second_scale_duration: float = 0.2
@export var collect_scale: float = 1.5
@export var collect_scale_duration: float = 0.2

var time: float
var tick_tweens_enabled: bool = true


func _ready() -> void:
    time = starting_time
    GlobalSignalBus.item_collected.connect(
        func(_item):
            time += collection_bonus
            tick_tweens_enabled = false
            scale_for(collect_scale,
                collect_scale_duration
            ).tween_callback(
                func(): tick_tweens_enabled = true
            )
    )

func _process(delta: float) -> void:
    time -= delta
    var is_second: bool = floor(time + delta) != floor(time)
    if tick_tweens_enabled && is_second:
        if int(time) % 10 == 0:
            scale_for(ten_second_scale,
                ten_second_scale_duration
            )
        else: scale_for(second_scale,
            second_scale_duration)

    if time < 0:
        GlobalSignalBus.notify_game_timer_ended()
        time = 0
    text = get_clock_string(time)


static func get_clock_string(seconds: float) -> String:
    var minutes = floor(seconds / 60)
    var partial_seconds = seconds - int(seconds)
    seconds = floori(seconds - minutes * 60)
    return "%01d:%02d:%02d" % [minutes, seconds, floori(partial_seconds * 100)]
