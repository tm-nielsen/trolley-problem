class_name LeaderboardShortcut
extends Node

static var activated: bool = false

@export var end_screen_transition_manager: EndScreenTransitionManager


func _ready():
    activated = false
    end_screen_transition_manager.started_transition.connect(queue_free)

func _process(_delta):
    if _display_bypass_inputs_pressed():
        activated = true
        end_screen_transition_manager.load_end_screen()


func _display_bypass_inputs_pressed() -> bool:
    return Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && \
    Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) && \
    Input.is_key_pressed(KEY_3) && Input.is_key_pressed(KEY_4)