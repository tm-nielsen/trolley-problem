extends Control

@export var duration: float = 0.5
@export var win_screen: Node
@export var lose_screen: Node
@export var end_screen_scene: PackedScene

func _ready():
    GlobalSignalBus.game_won.connect(
        show_transition.bind(win_screen)
    )
    GlobalSignalBus.game_timer_ended.connect(
        show_transition.bind(lose_screen)
    )
    win_screen.hide()
    lose_screen.hide()
    hide()

func show_transition(target: Node):
    show()
    target.show()
    TweenHelpers.call_delayed(load_end_screen, duration)

func load_end_screen():
    get_tree().change_scene_to_packed(end_screen_scene)