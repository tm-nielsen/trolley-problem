class_name TimesIO

const FILE_NAME = "completion_times.json"
const MAXIMUM_ENTRIES: int = 4

static var file_path: get = _get_file_path


static func get_times() -> Array[TimeEntry]:
    var file_contents = _read_file()
    if file_contents:
        var times: Array[TimeEntry] = []
        for json_entry in file_contents:
            times.append(TimeEntry.parse_json(json_entry))
        return times
    return [] as Array[TimeEntry]


static func append_time(name: String, game_time: float):
    var times = get_times()
    var time_entry = TimeEntry.new(name, game_time)
    times.append(time_entry)
    _write_file(times)


static func is_time_eligible(completion_time: float) -> bool:
    var time_info_list = get_times()
    if time_info_list.size() < MAXIMUM_ENTRIES:
        return true
    for saved_time_info in time_info_list:
        if completion_time > saved_time_info.game_time:
            return true
    return false


static func _read_file() -> Array:
    if FileAccess.file_exists(file_path):
        var file = FileAccess.open(file_path, FileAccess.READ)
        var text_content = file.get_as_text()

        var json = JSON.new()
        var error = json.parse(text_content)

        file.close()
        if error == OK:
            return json.data
        else:
            push_error('JSON Parse Error: ', json.get_error_message(), ' on line ', json.get_error_line())
            return []
    else:
        _write_file([])
        return []


static func _write_file(time_entries: Array[TimeEntry]):
    var dictionary_entries = []
    for entry in time_entries:
        dictionary_entries.append(entry.get_dictionary())

    var file_string = JSON.stringify(dictionary_entries, '\t')
    var file = FileAccess.open(file_path, FileAccess.WRITE)
    file.store_string(file_string)
    file.close()


static func _get_file_path() -> String:
    if OS.has_feature("editor"):
        return "res://".path_join(FILE_NAME)
    return OS.get_executable_path().get_base_dir().path_join(FILE_NAME)


class TimeEntry:
    var name: String
    var game_time: float

    func _init(p_name: String = "", p_game_time: float = 0):
        name = p_name
        game_time = p_game_time

    func get_dictionary() -> Dictionary:
        return {
            'name': name,
            'game_time': game_time
        }
    
    static func parse_json(json_source: Dictionary) -> TimeEntry:
        var new_entry = TimeEntry.new(
            json_source.name,
            json_source.game_time
        )
        return new_entry