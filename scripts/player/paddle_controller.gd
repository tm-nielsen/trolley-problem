class_name PaddleController
extends Node3D

signal pushed(push_scale: float)
signal jumped

@export var flick_window: float = 0.1
@export var full_stroke_push_scale: float = 3

@export_subgroup("input keys", "key")
@export var key_paddle_back: Key
@export var key_paddle_forward: Key
@export var key_paddle_up: Key
@export var key_paddle_down: Key

@onready var paddle_back := KeyProxy.new(key_paddle_back)
@onready var paddle_forward := KeyProxy.new(key_paddle_forward)
@onready var paddle_up := KeyProxy.new(key_paddle_up)
@onready var paddle_down := KeyProxy.new(key_paddle_down)

var jump_window := KeyProxy.InputWindow.new()


func _process(_delta: float) -> void:
    for key_proxy in [paddle_back, paddle_forward, paddle_up, paddle_down]:
        key_proxy.update()

    if paddle_down.is_pressed:
        process_stroke(paddle_back, paddle_forward, 1)
        process_stroke(paddle_forward, paddle_back, -1)
    if (
        paddle_down.was_pressed_this_frame &&
        paddle_up.was_pressed_within(flick_window)
    ): jumped.emit()

func process_stroke(
    action_key: KeyProxy,
    windup_key: KeyProxy,
    direction: int = 1
):
    if !action_key.was_pressed_this_frame: return
    pushed.emit(
        (full_stroke_push_scale if
        was_flicked(windup_key) else 1.0)
        * direction
    )

func was_jump_flicked() -> bool:
    return jump_window.was_triggered_within(flick_window)

func was_flicked(key_proxy: KeyProxy) -> bool:
    return key_proxy.was_pressed_within(flick_window)