class_name CameraView
extends Control

@export var viewport_container: SubViewportContainer
@export var viewport: SubViewport
@export var viewport_size: int = 100

var camera: TrackingCamera


func _ready() -> void:
    viewport_container.stretch_shrink = int(
        viewport_container.size.x / viewport_size
    )

func initialize_camera(camera_position: Vector3):
    camera = TrackingCamera.new()
    viewport.add_child(camera)
    camera.position = camera_position
    camera.make_current()

func set_camera(source_camera: TrackingCamera):
    camera.copy_from(source_camera)
