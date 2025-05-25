extends Control

func _ready() -> void:
    GlobalSignalBus.game_won.connect(activate)
    hide()

func _process(_delta: float) -> void:
    if !visible: return
    if Input.is_action_just_pressed("replay"):
        get_tree().paused = false
        get_tree().reload_current_scene()

func activate():
    get_tree().paused = true
    show()