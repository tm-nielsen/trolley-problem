extends AudioStreamPlayer3D

func _ready():
    GlobalSignalBus.tutorial_completed.connect(play)