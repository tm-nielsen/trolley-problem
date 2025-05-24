class_name KeyProxy

var is_pressed: bool
var was_pressed_this_frame: bool
var keycode: Key

func _init(p_keycode: Key):
    keycode = p_keycode

func update():
    var currently_pressed = Input.is_key_pressed(keycode)
    was_pressed_this_frame = currently_pressed && !is_pressed
    is_pressed = currently_pressed