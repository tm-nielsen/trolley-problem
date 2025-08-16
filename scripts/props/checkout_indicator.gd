extends Node3D

func _ready():
    GlobalSignalBus.all_items_collected.connect(show)
    hide()

func _process(_delta):
    var offset = WinArea.indicator_position - global_position
    global_rotation.y = atan2(offset.x, offset.z)