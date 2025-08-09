class_name CartAnimator
extends Node3D

@export var mesh: MeshInstance3D
@export var collision_momentum_threshold: float = 20
@export var collision_pose_duration: float = 0.2
@export_subgroup("mesh animation frames", "surface_index")
@export var surface_index_normal: int = 3
@export var surface_index_collided: int = 4
@export_subgroup("mesh animation materials", "material")
@export var material_body: ShaderMaterial
@export var material_hidden: ShaderMaterial
@export var material_collided: ShaderMaterial

@export_subgroup("wiggle", "wiggle")
@export var wiggle_target: BoneAttachment3D
@export var wiggle_rotation_sensitivity := Vector2(50, 50)
@export var wiggle_position_sensitivity := Vector3(1, 1, 1)
@export_subgroup("wiggle/resources", "elastic_wiggle")
@export var elastic_wiggle_rotation: ElasticVector2
@export var elastic_wiggle_position: ElasticVector2
@export var elastic_wiggle_height: ElasticValue

var collision_tween: Tween
var current_body_mesh_index: int

@onready var default_wiggle_transform := wiggle_target.transform
@onready var previous_position := global_position
var previous_velocity := Vector3.ZERO


func _ready() -> void:
    current_body_mesh_index = surface_index_collided
    show_mesh_pose(surface_index_normal)
    default_wiggle_transform = wiggle_target.transform


func _process(delta: float) -> void:
    var aligned_acceleration := update_movement_values()
    update_elastic_values(aligned_acceleration, delta)
    apply_elastic_values()


func update_elastic_values(acceleration: Vector3, delta: float):
    var planar_acceleration := Vector2(acceleration.x, acceleration.z)
    elastic_wiggle_rotation.value_velocity += planar_acceleration
    elastic_wiggle_rotation.update_value(Vector2.ZERO, delta)
    elastic_wiggle_position.value_velocity += planar_acceleration
    elastic_wiggle_position.update_value(Vector2.ZERO, delta)
    elastic_wiggle_height.value_velocity += acceleration.y
    elastic_wiggle_height.update_value(0, delta)


func apply_elastic_values():
    wiggle_target.transform = default_wiggle_transform
    wiggle_target.position += Vector3(
        elastic_wiggle_position.x,
        elastic_wiggle_height.value,
        elastic_wiggle_position.y
    )
    wiggle_target.rotation += Vector3(
        elastic_wiggle_rotation.y,
        0,
        elastic_wiggle_rotation.x
    )


func update_movement_values() -> Vector3:
    var velocity := global_position - previous_position
    var acceleration := velocity - previous_velocity
    previous_position = global_position
    previous_velocity = velocity
    return acceleration * basis.inverse()


func show_mesh_pose(surface_index: int, material := material_body):
    mesh.set_surface_override_material(
        current_body_mesh_index, material_hidden
    )
    mesh.set_surface_override_material(
        surface_index, material
    )
    current_body_mesh_index = surface_index

func _on_cart_collided(collision_momentum: float):
    if collision_momentum < collision_momentum_threshold: return
    show_mesh_pose(surface_index_collided, material_collided)
    if collision_tween: collision_tween.kill()
    collision_tween = create_tween()
    collision_tween.tween_interval(collision_pose_duration)
    collision_tween.tween_callback(
        show_mesh_pose.bind(surface_index_normal)
    )
