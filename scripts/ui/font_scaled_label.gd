class_name FontScaledLabel
extends Label

@onready var base_font_size = label_settings.font_size

var scale_tween: Tween


func scale_for(font_scale: float, duration: float) -> Tween:
    _set_font_scale(font_scale)
    if (scale_tween): scale_tween.kill()
    scale_tween = TweenHelpers.build_tween(self)
    scale_tween.tween_property(
        label_settings, "font_size", base_font_size, duration
    )
    return scale_tween

func _set_font_scale(font_scale: float = 1):
    label_settings.font_size = int(base_font_size * font_scale)
