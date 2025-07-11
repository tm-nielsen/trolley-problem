extends Node

const FILE_NAME := "settings.ini"

var timeout_enabled: bool
var timeout_period: int
var volume: float

var last_input_timestamp: int = 0

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    var config = ConfigFile.new()
    load_settings(config)
    save_settings(config)
    apply_volume_settings()
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(_event):
    last_input_timestamp = Time.get_ticks_msec()

func _process(_delta):
    var time_delta = Time.get_ticks_msec() - last_input_timestamp
    var seconds_since_last_input = time_delta / 1000.0
    if seconds_since_last_input > timeout_period:
        get_tree().quit()


func load_settings(config: ConfigFile):
    config.load(get_file_path())

    var arcade_mode_enabled = OS.get_cmdline_args().has("--arcade")
    timeout_enabled = config.get_value("SYSTEM", "timeout_enabled", arcade_mode_enabled)
    timeout_period = config.get_value("SYSTEM", "timeout_period_seconds", 180)

    volume = config.get_value("SYSTEM", "volume", 1.0)


func save_settings(config: ConfigFile):
    config.set_value("SYSTEM", "timeout_enabled", timeout_enabled)
    config.set_value("SYSTEM", "timeout_period_seconds", timeout_period)
    config.set_value("SYSTEM", "volume", volume)
    config.save(get_file_path())


func apply_volume_settings():
    var master_bus_index = AudioServer.get_bus_index("Master")
    AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(volume))


func get_file_path() -> String:
    if OS.has_feature("editor"):
        return "res://".path_join(FILE_NAME)
    return OS.get_executable_path().get_base_dir().path_join(FILE_NAME)
