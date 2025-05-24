class_name CameraView
extends Control

@export var viewport_container: SubViewportContainer
@export var viewport: SubViewport
@export var label: Label
@export var viewport_size: int = 100

var camera: TrackingCamera


func _ready() -> void:
    (func(): viewport_container.stretch_shrink = int(
        viewport_container.size.x / viewport_size
    )).call_deferred()

func initialize(camera_position: Vector3, title: String):
    camera = TrackingCamera.new()
    viewport.add_child(camera)
    camera.position = camera_position
    camera.make_current()
    label.text = title

func set_camera(source_camera: TrackingCamera):
    camera.copy_from(source_camera)
