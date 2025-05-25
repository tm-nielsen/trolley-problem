extends FontScaledLabel

@export var suffix: String = "Wares Craved"
@export var collected_scale: float = 0.5
@export var collected_tween_duration: float = 0.1

var item_count: int


func _ready() -> void:
    GlobalSignalBus.collection_pool_populated.connect(
        func(items: Array):
        set_and_display_item_count(items.size())
    )
    GlobalSignalBus.item_collected.connect(
        func(_item):
        set_and_display_item_count(item_count - 1)
        scale_for(collected_scale, collected_tween_duration)
    )


func set_and_display_item_count(count: int):
    item_count = count
    text = "%d\n%s" % [item_count, suffix]
    if item_count == 0: hide()