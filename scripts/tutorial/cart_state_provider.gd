extends Node3D

@export var tutorial_cart: CartBody

func _ready():
    GlobalSignalBus.tutorial_completed.connect(
        func():
            GlobalSignalBus.provide_cart_state(
            CartState.new(tutorial_cart, global_position)
        )
    )
