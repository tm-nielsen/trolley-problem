class_name CollectableItem
extends Area3D

signal collected

@export var default_item: PackedScene
@export var mesh: MeshInstance3D


func _ready():
    show_item(default_item)

func show_item(prefab: PackedScene):
    if !prefab: return
    var instance: Node3D = prefab.instantiate()
    var prefab_mesh = _find_mesh_instance(instance)
    mesh.mesh = prefab_mesh.mesh
    instance.queue_free()


func _find_mesh_instance(parent: Node3D) -> MeshInstance3D:
    for child in parent.get_children():
        if child is MeshInstance3D: return child
        var child_search = _find_mesh_instance(child)
        if child_search != null: return child_search
    return null


func _on_body_entered(body: Node3D):
    if body is CartBody:
        collected.emit()
        GlobalSignalBus.notify_item_collected(self)
        queue_free()