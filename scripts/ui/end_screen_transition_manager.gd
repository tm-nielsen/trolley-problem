class_name EndScreenTransitionManager
extends Control

signal started_transition

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
    started_transition.emit()
    TweenHelpers.call_delayed(load_end_screen, duration)

func load_end_screen():
    for doomed_node in get_parent().get_children():
        if is_instance_valid(doomed_node):
            doomed_node.queue_free()
    get_parent().add_child(end_screen_scene.instantiate())