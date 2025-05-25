class_name FontScaledLabel
extends Label

@onready var base_font_size = label_settings.font_size

func scale_for(font_scale: float, duration: float):
    _set_font_scale(font_scale)
    TweenHelpers.call_delayed(_set_font_scale, duration)

func _set_font_scale(font_scale: float = 1):
    label_settings.font_size = int(base_font_size * font_scale)
