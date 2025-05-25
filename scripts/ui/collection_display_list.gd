extends Control

@export var label_settings: LabelSettings
@export var collected_initial_colour := Color.WEB_GREEN
@export var collected_colour := Color.WEB_GRAY
@export var collected_initial_scale: float = 1.3
@export var collected_scale: float = 0.8
@export var collected_tween_duration: float = 0.25

var displays: Array[CollectableItemDisplay]

func _ready() -> void:
    GlobalSignalBus.collection_pool_populated.connect(
        initialize_item_displays
    )
    GlobalSignalBus.item_collected.connect(
        toggle_item_listing
    )


func initialize_item_displays(items: Array[CollectableItem]):
    for child in get_children(): child.queue_free()
    for collectable in items:
        var label = Label.new()
        label.label_settings = label_settings
        displays.append(CollectableItemDisplay.new(label, collectable))
        add_child(label)

func toggle_item_listing(item: CollectableItem):
    for display in displays:
        if display.matches_item(item):
            display.toggle_label_text()
            start_collected_tween(display.label)

func start_collected_tween(target: Label):
    var new_settings: LabelSettings = label_settings.duplicate()
    new_settings.font_color = collected_initial_colour
    new_settings.font_size = int(
        label_settings.font_size * collected_initial_scale
    )
    target.label_settings = new_settings
    var collected_tween = TweenHelpers.create_tween()
    collected_tween.set_parallel()
    collected_tween.tween_property(
        new_settings, "font_size",
        new_settings.font_size * collected_scale,
        collected_tween_duration
    )
    collected_tween.tween_property(
        target.label_settings, "font_color", collected_colour,
        collected_tween_duration
    )



class CollectableItemDisplay:
    var label: Label
    var source_item: CollectableItem

    func _init(p_label: Label, p_item: CollectableItem):
        label = p_label
        source_item = p_item
        label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        label.size_flags_vertical = Control.SIZE_EXPAND_FILL
        label.text = source_item.item_name + " [  ]"

    func matches_item(item: CollectableItem) -> bool:
        return item == source_item

    func toggle_label_text():
        label.text = source_item.item_name + " [x]"