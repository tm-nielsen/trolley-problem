extends FontScaledLabel

@export var completion_text := "Check Out!"
@export var competion_font_size: float = 26

@export_subgroup("signal tween")
@export var collection_tween_scale: float = 0.5
@export var collection_tween_duration: float = 0.4
@export var completion_tween_scale: float = 2.0
@export var completion_tween_duration: float = 0.6

@export_subgroup("completion bump", "completion_bump")
@export var completion_bump_scale: float = 1.2
@export var completion_bump_tween_duration: float = 0.5
@export var completion_bump_minimum_period: float = 0.1
@export var completion_bump_maximum_period: float = 1.0


func _ready():
    GlobalSignalBus.item_collected.connect(
        func(_item):
        scale_for(
            collection_tween_scale,
            collection_tween_duration
        )
    )
    GlobalSignalBus.all_items_collected.connect(
        func():
        text = completion_text
        base_font_size = competion_font_size
        scale_for(
            completion_tween_scale,
            completion_tween_duration
        )
        TweenHelpers.call_delayed(
            run_completion_bump,
            completion_tween_duration
        )
    )

func run_completion_bump():
    scale_for(completion_bump_scale, completion_bump_tween_duration)
    TweenHelpers.call_delayed(
        run_completion_bump, randf_range(
            completion_bump_minimum_period,
            completion_bump_maximum_period
        )
    )