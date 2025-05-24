class_name KeyProxy

var is_pressed: bool
var was_pressed_this_frame: bool
var pressed_value: int

var keycode: Key
var pressed_window := InputWindow.new()

func _init(p_keycode: Key):
    keycode = p_keycode

func update():
    var currently_pressed = Input.is_key_pressed(keycode)
    was_pressed_this_frame = currently_pressed && !is_pressed
    is_pressed = currently_pressed
    pressed_value = 1 if is_pressed else 0
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