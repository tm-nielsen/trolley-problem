class_name CollectableItem
extends Area3D

signal collected

static var item_name_regex := RegEx.new().compile("(\\w).")

@export var collection_effect: PackedScene
@export var mesh: MeshInstance3D
@export var default_item: PackedScene

var item_name: String


func _ready():
    show_item(default_item)

func show_item(prefab: PackedScene):
    if !prefab: return
    var instance: Node3D = prefab.instantiate()
    mesh.mesh = _find_mesh_instance(instance).mesh
    item_name = _get_prefab_name(prefab)
    instance.queue_free()


func _find_mesh_instance(parent: Node3D) -> MeshInstance3D:
    for child in parent.get_children():
        if child is MeshInstance3D: return child
        var child_search = _find_mesh_instance(child)
        if child_search != null: return child_search
    return null

func _get_prefab_name(prefab: PackedScene) -> String:
    var name_regex = RegEx.new()
    name_regex.compile("_(\\w+)\\.")
    return name_regex.search(prefab.resource_path).get_string(1)


func _on_body_entered(body: Node3D):
    if body is CartBody:
        collected.emit()
        GlobalSignalBus.notify_item_collected(self)
        var effect: CPUParticles3D = collection_effect.instantiate()
        effect.position = position
        effect.finished.connect(effect.queue_free)
        effect.emitting = true
        add_sibling(effect)
        queue_free()
