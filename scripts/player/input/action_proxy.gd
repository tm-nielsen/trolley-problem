class_name ActionProxy

var is_pressed: bool
var was_pressed_this_frame: bool
var pressed_value: float

var action_name: String
var pressed_window := InputWindow.new()

func _init(p_action_name: String):
    action_name = p_action_name

func update():
    var currently_pressed = Input.is_action_pressed(action_name)
    was_pressed_this_frame = currently_pressed && !is_pressed
    is_pressed = currently_pressed
    pressed_value = Input.get_action_strength(action_name)
    if is_pressed: pressed_window.activate()

func was_pressed_within(seconds: float) -> bool:
    return pressed_window.was_triggered_within(seconds)

class InputWindow:
    var last_activation_time: int

    func activate(): last_activation_time = Time.get_ticks_msec()
    func was_triggered_within(seconds: float) -> bool:
        var msecs_since_last_activation := (
            Time.get_ticks_msec() - last_activation_time
        )
        return msecs_since_last_activation < seconds * 1000