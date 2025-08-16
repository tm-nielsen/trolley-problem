class_name CartState

var position: Vector3
var rotation: Vector3
var velocity: Vector3
var angular_velocity: float


func _init(source: CartBody, reference_position := Vector3.ZERO):
    position = source.global_position - reference_position
    rotation = source.rotation
    velocity = source.velocity
    angular_velocity = source.angular_velocity

func apply(target: CartBody, reference_position := Vector3.ZERO):
    target.global_position = reference_position + position
    target.rotation = rotation
    target.velocity = velocity
    target.angular_velocity = angular_velocity