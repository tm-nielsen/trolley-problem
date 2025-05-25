class_name PickupItemPool
extends Node3D

signal completed

@export var item_count: int = 4
@export var collected_count: int = 0

func _ready():
    var cull_list = get_children()
    for i in item_count:
        var picked = cull_list.pick_random()
        picked.collected.connect()
        cull_list.erase(picked)
    for doomed in cull_list:
        doomed.queue_free()

func _on_item_collected():
    collected_count += 1
    if collected_count >= item_count: completed.emit()