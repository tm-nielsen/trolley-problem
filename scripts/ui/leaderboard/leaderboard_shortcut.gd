class_name LeaderboardShortcut
extends Node

static var activated: bool = false

@export var leaderboard_scene: PackedScene


func _ready():
    activated = false

func _process(_delta):
    if _display_bypass_inputs_pressed():
        activated = true
        get_tree().change_scene_to_packed(leaderboard_scene)


func _display_bypass_inputs_pressed() -> bool:
    return Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && \
    Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) && \
    Input.is_key_pressed(KEY_3) && Input.is_key_pressed(KEY_4)