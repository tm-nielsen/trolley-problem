class_name PaddleController
extends Node3D

signal pushed(push_scale: float)
signal jumped
signal hit_ground

enum ActionPrefix {LEFT, RIGHT}
const PREFIX_STRINGS = {
    ActionPrefix.LEFT: "left",
    ActionPrefix.RIGHT: "right"
}

@export var flick_window: float = 0.1
@export var full_stroke_push_scale: float = 3
@export var action_prefix: ActionPrefix

@onready var paddle_back := make_action_proxy("back")
@onready var paddle_forward := make_action_proxy("forward")
@onready var paddle_up := make_action_proxy("up")
@onready var paddle_down := make_action_proxy("down")

var jump_window := ActionProxy.InputWindow.new()


func _process(_delta: float) -> void:
    update_proxies()
    process_input_movements()


func update_proxies():
    for key_proxy in [paddle_back, paddle_forward, paddle_up, paddle_down]:
        key_proxy.update()

func process_input_movements():
    if paddle_down.is_pressed:
        process_stroke(paddle_back, paddle_forward, 1)
        process_stroke(paddle_forward, paddle_back, -1)

    if paddle_down.was_pressed_this_frame:
        hit_ground.emit()
        if paddle_up.was_pressed_within(flick_window):
            jumped.emit()


func process_stroke(
    action_key: ActionProxy,
    windup_key: ActionProxy,
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

func was_flicked(key_proxy: ActionProxy) -> bool:
    return key_proxy.was_pressed_within(flick_window)


func make_action_proxy(direction_string: String) -> ActionProxy:
    var prefix_string = PREFIX_STRINGS[action_prefix]
    return ActionProxy.new(
        "%s paddle %s" % [prefix_string, direction_string]
    )