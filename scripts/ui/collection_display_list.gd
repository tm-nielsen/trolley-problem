extends Control

@export var label_settings: LabelSettings

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
        display.toggle_display_if_matches_item(item)


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

    func toggle_display_if_matches_item(item: CollectableItem):
        if item == source_item:
            label.text = source_item.item_name + " [x]"