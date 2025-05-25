class_name ElasticVector2
extends Resource

@export var elasticity := Vector2(0.05, 0.05)
@export var friction := Vector2(0.2, 0.2)

var value_velocity: Vector2
var value: Vector2

var x: get = _get_x
var y: get = _get_y


func update_value(target: Vector2, delta: float) -> Vector2:
    var delta_scale = delta * ElasticValue.SCALING_FRAMERATE
    var x_offset = target.x - x
    var y_offset = target.y - y
    value_velocity += Vector2(x_offset, y_offset) * elasticity * delta_scale
    value += value_velocity
    value_velocity = apply_friction(value_velocity, friction, delta_scale)
    return value


static func apply_friction(a: Vector2, f: Vector2, delta_scale: float) -> Vector2:
    a.x = ElasticValue.apply_friction(a.x, f.x, delta_scale)
    a.y = ElasticValue.apply_friction(a.y, f.y, delta_scale)
    return a


func _get_x() -> float: return value.x
func _get_y() -> float: return value.y