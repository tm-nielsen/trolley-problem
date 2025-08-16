class_name CartBody
extends CharacterBody3D

static var cart_position: Vector3

signal collided(collider_mass: float)

@export_subgroup("movement forces")
@export var push_force: float = 4
@export var turn_force: float = 4
@export var jump_force: float = 2
@export var friction: float = 1
@export var angular_friction: float = 4

@export_subgroup("paddles")
@export var right_paddle: PaddleController
@export var left_paddle: PaddleController

@export_subgroup("rigidbody interaction")
@export var effective_mass: float = 2
@export var inertia: float = 0.1

var angular_velocity: float


func _ready() -> void:
    right_paddle.pushed.connect(apply_push.bind(-1))
    left_paddle.pushed.connect(apply_push.bind(1))
    right_paddle.jumped.connect(apply_jump.bind(left_paddle))
    left_paddle.jumped.connect(apply_jump.bind(right_paddle))

func _physics_process(delta: float) -> void:
    velocity += get_gravity() * delta
    if is_on_floor():
        velocity *= max(1 - friction * delta, 0)
        angular_velocity *= max(1 - angular_friction * delta, 0)
        velocity = velocity.rotated(Vector3.UP, angular_velocity)
    rotate_y(angular_velocity)
    process_movement()
    cart_position = global_position


func apply_push(push_scale: float, turn_direction: float):
    velocity += basis.z * push_force * push_scale
    angular_velocity += turn_force / 100 * push_scale * turn_direction

func apply_jump(opposite_paddle: PaddleController):
    if opposite_paddle.was_jump_flicked():
        velocity.y += jump_force * 4
    elif is_on_floor():
        velocity.y += jump_force


func process_movement():
    var result_velocity := velocity
    move_and_slide()
    for i in get_slide_collision_count():
        result_velocity = _process_slide_collision(
            i, result_velocity
        )


func _process_slide_collision(
    index: int, previous_velocity: Vector3
) -> Vector3:
    var collision := get_slide_collision(index)
    var colliding_body = collision.get_collider()
    if colliding_body is RigidBody3D:
        return _process_rigidbody_collision(
            colliding_body, collision.get_normal(),
            previous_velocity
        )
    elif colliding_body.name != "Ground":
        collided.emit(previous_velocity.length() * 5)
    return previous_velocity
    
func _process_rigidbody_collision(
    colliding_body: RigidBody3D, normal: Vector3,
    previous_velocity: Vector3
) -> Vector3:
    var collider_mass = colliding_body.mass
    collided.emit(collider_mass * previous_velocity.length())
    var mass_ratio = effective_mass / collider_mass
    colliding_body.apply_central_impulse(-normal * mass_ratio)
    return previous_velocity * inertia / collider_mass