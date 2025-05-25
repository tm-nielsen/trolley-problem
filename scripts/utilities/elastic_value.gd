class_name ElasticValue
extends Resource

const SCALING_FRAMERATE = 60

@export var elasticity: float = 0.05
@export_range(0, 1) var friction: float = 0.2

var value_velocity: float
var value: float


func update_value(target: float, delta: float) -> float:
    var delta_scale = delta * SCALING_FRAMERATE
    var offset = target - value
    value_velocity += offset * elasticity * delta_scale
    value += value_velocity
    value_velocity = apply_friction(value_velocity, friction, delta_scale)
    return value


static func apply_friction(a: float, f: float, delta_scale: float) -> float:
    return a * max(1 - f * delta_scale, 0)