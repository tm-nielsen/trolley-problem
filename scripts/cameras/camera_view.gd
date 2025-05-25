class_name CameraView
extends Control

@export var fov: float = 75
@export var viewport: SubViewport
@export var label: Label

var camera: TrackingCamera


func initialize(camera_position: Vector3, title: String):
    camera = TrackingCamera.new()
    camera.fov = fov
    viewport.add_child(camera)
    camera.position = camera_position
    camera.make_current()
    label.text = title

func set_camera(source_camera: TrackingCamera):
    camera.copy_from(source_camera)
