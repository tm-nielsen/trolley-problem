extends Control

@export var checkbox_prefab: PackedScene

var checkbox_bindings: Dictionary[CollectableItem, ScalableColourPanel]
var item_count: int


func _ready() -> void:
    GlobalSignalBus.collection_pool_populated.connect(
        build_item_checkboxes
    )
    GlobalSignalBus.item_collected.connect(
        func(item):
        checkbox_bindings[item].turn_on()
    )


func build_item_checkboxes(items: Array[CollectableItem]):
    for item in items:
        var new_checkbox = checkbox_prefab.instantiate()
        add_child(new_checkbox)
        checkbox_bindings[item] = new_checkbox
        center_checkbox_children.call_deferred()

func center_checkbox_children():
    for checkbox in get_children():
        if !checkbox is ScalableColourPanel: return
        checkbox.scale_node.pivot_offset = checkbox.scale_node.size / 2