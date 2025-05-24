class_name TrackingCamera
extends Camera3D

func _process(_delta: float) -> void:
    look_at(CartBody.cart_position)

func copy_from(source: TrackingCamera) -> void:
    transform = source.transform