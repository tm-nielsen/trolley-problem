extends Node3D

signal completed

enum State {INTRO, RIGHT_PADDLE, LEFT_PADDLE, COMPLETE}
const INTRO = State.INTRO
const RIGHT_PADDLE = State.RIGHT_PADDLE
const LEFT_PADDLE = State.LEFT_PADDLE
const COMPLETE = State.COMPLETE

@export var cutscene_animator: AnimationPlayer
@export var cutscene_parent: Node3D
@export var gameplay_parent: Node3D
@export var gameplay_camera: Camera3D
@export var exit_area: Area3D

@export_subgroup("paddle prompts")
@export var directional_prompt_display: DirectionalPromptDisplay
@export var right_paddle: PaddleController
@export var left_paddle: PaddleController

@onready var moveable_paddle_parent := right_paddle.get_parent()
var state := State.INTRO


func _ready() -> void:
    completed.connect(GlobalSignalBus.notify_tutorial_completed)
    gameplay_parent.process_mode = Node.PROCESS_MODE_DISABLED
    gameplay_parent.hide()
    cutscene_parent.show()
    cutscene_animator.animation_finished.connect(
        _on_cutscene_animation_completed
    )
    moveable_paddle_parent.process_mode = Node.PROCESS_MODE_DISABLED
    moveable_paddle_parent.hide()
    directional_prompt_display.all_directions_pressed.connect(
        _on_direction_prompts_completed
    )
    exit_area.body_entered.connect(_on_exit_area_entered)


func _on_cutscene_animation_completed(animation_name: String):
    if animation_name == "intro":
        moveable_paddle_parent.process_mode = Node.PROCESS_MODE_PAUSABLE
        moveable_paddle_parent.show()
        directional_prompt_display.display_prompts(right_paddle)
        state = RIGHT_PADDLE
    if animation_name == "show_left":
        directional_prompt_display.display_prompts(left_paddle)
        state = LEFT_PADDLE

func _on_direction_prompts_completed():
    match state:
        RIGHT_PADDLE:
            cutscene_animator.play("show_left")
            directional_prompt_display.display_prompts(left_paddle)
            state = LEFT_PADDLE
        LEFT_PADDLE:
            gameplay_parent.process_mode = Node.PROCESS_MODE_PAUSABLE
            cutscene_parent.queue_free()
            gameplay_parent.show()
            gameplay_camera.make_current()
            state = COMPLETE

func _on_exit_area_entered(body: Node3D):
    if body is CartBody: completed.emit()