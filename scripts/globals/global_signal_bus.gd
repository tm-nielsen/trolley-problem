extends Node

signal collection_pool_populated(items: Array[CollectableItem])
signal item_collected(item: CollectableItem)
signal all_items_collected()
signal game_won()

func notify_collection_pool_populated(items: Array[CollectableItem]):
    collection_pool_populated.emit(items)

func notify_item_collected(item: CollectableItem):
    item_collected.emit(item)

func notify_last_item_collected():
    all_items_collected.emit()

func notify_win_area_entered():
    game_won.emit()