class_name PaddleController
extends Node3D

signal pushed_forward
signal pushed_up
signal pushed_back

@export_subgroup("input keys", "key")
@export var key_up: Key
@export var key_down: Key
@export var key_left: Key
@export var key_right: Key

@onready var up := KeyProxy.new(key_up)
@onready var down := KeyProxy.new(key_down)
@onready var left := KeyProxy.new(key_left)
@onready var right := KeyProxy.new(key_right)


func _process(_delta: float) -> void:
    for key_proxy in [up, down, left, right]:
        key_proxy.update()

    if up.was_pressed_this_frame: pushed_forward.emit()