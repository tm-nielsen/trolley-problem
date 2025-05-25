class_name CartAnimator
extends Node3D

@export var mesh: MeshInstance3D
@export var collision_pose_duration: float = 0.2
@export_subgroup("mesh animation frames", "surface_index")
@export var surface_index_normal: int = 3
@export var surface_index_collided: int = 4
@export_subgroup("mesh animation materials", "material")
@export var material_body: ShaderMaterial
@export var material_hidden: ShaderMaterial
@export var material_collided: ShaderMaterial

var current_body_mesh_index: int
var collision_tween: Tween


func _ready() -> void:
    current_body_mesh_index = surface_index_collided
    show_mesh_pose(surface_index_normal)


func show_mesh_pose(surface_index: int, material := material_body):
    mesh.set_surface_override_material(
        current_body_mesh_index, material_hidden
    )
    mesh.set_surface_override_material(
        surface_index, material
    )
    current_body_mesh_index = surface_index

func _on_cart_collided():
    show_mesh_pose(surface_index_collided, material_collided)
    if collision_tween: collision_tween.kill()
    collision_tween = create_tween()
    collision_tween.tween_interval(collision_pose_duration)
    collision_tween.tween_callback(
        show_mesh_pose.bind(surface_index_normal)
    )
