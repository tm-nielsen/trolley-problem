class_name CollectionPool
extends Node3D

@export var item_count: int = 4
@export var item_options: Array[PackedScene]

var collected_count: int = 0

func _ready():
    var cull_list = get_children()
    var picked_list: Array[CollectableItem] = []
    for i in item_count:
        var picked = cull_list.pick_random()
        picked_list.append(picked)
        picked.collected.connect(_on_item_collected)
        picked.show_item(item_options.pick_random())
        cull_list.erase(picked)
    for doomed in cull_list:
        doomed.queue_free()
    GlobalSignalBus.notify_collection_pool_populated(picked_list)

func _on_item_collected():
    collected_count += 1
    if collected_count >= item_count:
        GlobalSignalBus.notify_last_item_collected()