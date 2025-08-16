class_name AllItemsCollectedStretchRatioTweener
extends Control

@export var completion_ratio: float = 1.0
@export var tween_duration: float = 0.6

func _ready():
    GlobalSignalBus.all_items_collected.connect(
        func():
        TweenHelpers.build_tween(self) \
        .tween_property(
            self, "size_flags_stretch_ratio",
            completion_ratio, tween_duration
        )
    )
