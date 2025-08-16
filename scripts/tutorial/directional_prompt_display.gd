class_name DirectionalPromptDisplay
extends Control

signal all_directions_pressed

@export var completion_delay := 0.5
@export var completion_colour := Color.GREEN

@export_subgroup("references")
@export var up_light: ScalableColourPanel
@export var down_light: ScalableColourPanel
@export var left_light: ScalableColourPanel
@export var right_light: ScalableColourPanel

@export_subgroup("size tween", "size_tween")
@export var size_tween_scale: float = 1.5
@export var size_tween_duration: float = 0.4

@onready var lights = [
    up_light, down_light,
    left_light, right_light
]

var input_target: PaddleController
var mapped_lights
var completed := false


func _ready() -> void:
    hide()

func _process(_delta) -> void:
    if !visible: return
    for mapping in mapped_lights:
        check_direction(mapping[1], mapping[0])


func display_prompts(paddle_controller: PaddleController):
    input_target = paddle_controller
    map_lights_to_inputs()
    for light in lights: light.turn_off()
    completed = false
    show()

func map_lights_to_inputs():
    var invert_vertical = (
        input_target.action_prefix ==
        PaddleController.ActionPrefix.RIGHT
    )
    mapped_lights = [
        [up_light, input_target.paddle_up],
        [down_light, input_target.paddle_down],
        [
            left_light,
            input_target.paddle_forward if invert_vertical
            else input_target.paddle_back
        ],
        [
            right_light,
            input_target.paddle_back if invert_vertical
            else input_target.paddle_forward
        ]
    ]


func check_direction(action_proxy: ActionProxy, light: ScalableColourPanel):
    if action_proxy.was_pressed_this_frame:
        light.turn_on(!completed)
        if !completed: check_completion()

func check_completion():
    if all_lights_are_on():
        completed = true
        TweenHelpers.call_delayed(
            func():
                all_directions_pressed.emit()
                hide(),
            completion_delay
        )
        for light in lights:
            light.colour = completion_colour
        scale = Vector2.ONE * size_tween_scale
        TweenHelpers.build_tween(self).tween_property(
            self, "scale", Vector2.ONE, size_tween_duration
        )

func all_lights_are_on() -> bool:
    return lights.all(
        func(light): return light.is_on
    )
