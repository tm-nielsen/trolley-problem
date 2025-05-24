class_name TrackingCamera
extends Camera3D

@export var target_node: Node3D

func _process(_delta: float) -> void:
    if !target_node: return
    look_at(target_node.global_position)

func copy_from(source: TrackingCamera) -> void:
    transform = source.transform