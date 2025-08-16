class_name ScalableColourPanel
extends Control

@export var scale_node: Control = self
@export var colour_rect: ColorRect

@export_subgroup("colours")
@export var off_colour := Color.TRANSPARENT
@export var on_colour := Color.WHITE

@export_subgroup("tween settings", "tween")
@export var tween_on_scale: float = 1.5
@export var tween_on_duration: float = 0.4
@export var tween_off_scale: float = 0.8
@export var tween_off_duration: float = 0.6

var is_on: bool = false
var colour: get = _get_colour, set = _set_colour
var scale_tween: Tween


func _ready():
    if !is_instance_valid(scale_node): scale_node = self
    colour_rect.show_behind_parent = true
    colour_rect.color = off_colour


func turn_on(set_colour: bool = true):
    if set_colour: colour_rect.color = on_colour
    scale_for(tween_on_scale, tween_on_duration)
    is_on = true

func turn_off(set_colour: bool = true):
    if set_colour: colour_rect.color = off_colour
    scale_for(tween_off_scale, tween_off_duration)
    is_on = false


func scale_for(initial_scale: float, duration: float) -> Tween:
    scale_node.scale = Vector2.ONE * initial_scale
    if (scale_tween): scale_tween.kill()
    scale_tween = TweenHelpers.build_tween(self)
    scale_tween.tween_property(
        scale_node, "scale", Vector2.ONE, duration
    )
    return scale_tween


func _get_colour() -> Color: return colour_rect.color
func _set_colour(new_colour: Color) -> void: colour_rect.color = new_colour