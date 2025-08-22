extends Node3D

@export var door_animator: AnimationPlayer

func _ready():
    GlobalSignalBus.all_items_collected.connect(
        door_animator.play.bind("open")
    )