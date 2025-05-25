extends Label

@export var suffix: String = "Wares Craved"
@export var collected_scale: float = 0.5
@export var collected_tween_duration: float = 0.1

var base_font_size: int
var item_count: int


func _ready() -> void:
    GlobalSignalBus.collection_pool_populated.connect(
        func(items: Array):
        set_and_display_item_count(items.size())
    )
    GlobalSignalBus.item_collected.connect(
        func(_item):
        set_and_display_item_count(item_count - 1)
        start_collected_tween()
    )
    base_font_size = label_settings.font_size


func set_and_display_item_count(count: int):
    item_count = count
    text = "%d\n%s" % [item_count, suffix]
    if item_count == 0: hide()


func start_collected_tween():
    _set_font_scale(collected_scale)
    var size_tween = create_tween()
    size_tween.tween_interval(collected_tween_duration)
    size_tween.tween_callback(_set_font_scale)

func _set_font_scale(font_scale: float = 1):
    label_settings.font_size = int(base_font_size * font_scale)