extends Control

enum DisplayState {NAME_ENTRY, LEADERBOARD, RESET_ENABLED}
const NAME_ENTRY = DisplayState.NAME_ENTRY
const LEADERBOARD = DisplayState.LEADERBOARD
const RESET_ENABLED = DisplayState.RESET_ENABLED

@export var initial_display: Control
@export var final_display: Control

@export var completion_time_label: TimeLabel
@export var name_entry_area: NameEntryArea

@export var reset_prompt: Control
@export var reset_delay: float = 2
@export var game_scene: PackedScene

var display_state: DisplayState

var name_filter: NameFilter
var entered_name: String

var completion_time: float
var final_death_count: int


func _ready():
    name_filter = NameFilter.new()
    name_entry_area.name_changed.connect(_on_name_changed)
    name_entry_area.name_confirmed.connect(_on_name_confirmed)
    start_display()


func _process(_delta: float):
    if (
        display_state == RESET_ENABLED &&
        Input.is_action_just_pressed("replay")
    ):
        get_tree().change_scene_to_packed(game_scene)


func start_display():
    completion_time = GameTimer.completion_time
    completion_time_label.seconds = completion_time

    if LeaderboardShortcut.activated:
        display_leaderboard()
    else:
        display_name_entry()

func display_name_entry():
    display_state = NAME_ENTRY
    initial_display.show()
    final_display.hide()
    name_entry_area.start_name_selection()

func display_leaderboard():
    display_state = LEADERBOARD
    initial_display.hide()
    final_display.show()
    reset_prompt.hide()
    TweenHelpers.call_delayed_realtime(_enable_reset, reset_delay)


func _on_name_changed(new_name: String):
    if name_filter.test(new_name):
        name_entry_area.censor_name()

func _on_name_confirmed(confirmed_name: String):
    TimesIO.append_time(confirmed_name, completion_time)
    display_leaderboard()


func _enable_reset():
    reset_prompt.show()
    display_state = RESET_ENABLED