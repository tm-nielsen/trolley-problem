class_name CameraView
extends Control

@export var fov: float = 75
@export var viewport: SubViewport

var camera: TrackingCamera


func initialize(camera_position: Vector3):
    camera = TrackingCamera.new()
    camera.fov = fov
    viewport.add_child(camera)
    camera.position = camera_position
    camera.make_current()

func set_camera(source_camera: TrackingCamera):
    camera.copy_from(source_camera)
