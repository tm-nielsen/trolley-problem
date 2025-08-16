extends Node3D

@export var target: CartBody

func _ready():
    GlobalSignalBus.cart_state_provided.connect(
        func(state: CartState): state.apply(target, global_position)
    )
