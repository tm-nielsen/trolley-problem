class_name TimesIO

const FILEPATH = "user://trollery_problem_times.json"
const MAXIMUM_ENTRIES: int = 4

static func get_times() -> Array[Dictionary]:
    var file_contents = _read_file()
    if file_contents: return file_contents
    return []


static func append_time(name: String, game_time: float):
    var time_info_list = get_times()
    var time_info_oject = {"name": name, "game_time": game_time}
    time_info_list.append(time_info_oject)

    time_info_list.sort_custom(func(a, b): return a.game_time > b.game_time)
    if time_info_list.size() > MAXIMUM_ENTRIES:
            time_info_list.pop_back()
    _write_file(time_info_list)


static func is_time_eligible(completion_time: float) -> bool:
    var time_info_list = get_times()
    if time_info_list.size() < MAXIMUM_ENTRIES:
        return true
    for saved_time_info in time_info_list:
        if completion_time > saved_time_info.game_time:
            return true
    return false


static func _read_file() -> Array:
    if FileAccess.file_exists(FILEPATH):
        var file = FileAccess.open(FILEPATH, FileAccess.READ)
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


static func _write_file(time_entries: Array[Dictionary]):
    var file_string = JSON.stringify(time_entries, '\t')
    var file = FileAccess.open(FILEPATH, FileAccess.WRITE)
    file.store_string(file_string)
    file.close()