class_name KeyProxy

var is_pressed: bool
var was_pressed_this_frame: bool

var keycode: Key
var last_press_time: int

func _init(p_keycode: Key):
    keycode = p_keycode

func update():
    var currently_pressed = Input.is_key_pressed(keycode)
    was_pressed_this_frame = currently_pressed && !is_pressed
    is_pressed = currently_pressed
    if is_pressed: last_press_time = Time.get_ticks_msec()

func was_pressed_within(seconds: float):
    var msecs_since_last_press := (
        Time.get_ticks_msec() - last_press_time
    )
    return msecs_since_last_press < seconds * 1000