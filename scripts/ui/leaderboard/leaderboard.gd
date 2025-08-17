class_name Leaderboard
extends Control

@export var entry_prefab: PackedScene


func _ready():
  visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
  if visible:
    _show_entries()

func _show_entries():
  for child in get_children():
    child.queue_free()

  var completion_times = TimesIO.get_times()
  completion_times.sort_custom(func(a, b): return a.game_time < b.game_time)
  for entry in completion_times:
    var new_entry = entry_prefab.instantiate()
    new_entry.set_attributes(entry.name, entry.game_time)
    add_child(new_entry)