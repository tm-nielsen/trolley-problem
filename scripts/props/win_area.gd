extends Area3D

@export var indicator: Node3D
@export var flashing_period: float = 0.2


func _ready() -> void:
    body_entered.connect(_on_body_entered)
    GlobalSignalBus.all_items_collected.connect(activate)
    indicator.hide()
    monitoring = false

func activate():
    for body in get_overlapping_bodies():
        _on_body_entered(body)
    monitoring = true
    var flash_tween = create_tween().set_loops()
    flash_tween.tween_callback(indicator.show)
    flash_tween.tween_interval(flashing_period)
    flash_tween.tween_callback(indicator.hide)
    flash_tween.tween_interval(flashing_period)


func _on_body_entered(body: Node3D):
    if body is CartBody:
        GlobalSignalBus.notify_win_area_entered()