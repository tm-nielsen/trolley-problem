extends Node3D

@export var mass: float = 4

func _ready() -> void:
    for child in get_children():
        if child is RigidBody3D: 
            child.mass = mass
