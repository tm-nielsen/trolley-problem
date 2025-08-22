extends SFX_Player

@export var cart: CartBody
@export var big_hit_threshold: float = 10
@export var small_hit_noise: AudioStream
@export var big_hit_noise: AudioStream

@export_subgroup("volume_scaling")
@export var max_volume: float = 16
@export var min_volume: float = -12
@export var volume_scale_factor: float = 10

func _ready():
    cart.collided.connect(
        func(momentum):
        volume_db = remap(
            momentum / volume_scale_factor,
            0, 1, min_volume, max_volume
        )
        if (momentum > big_hit_threshold):
            play_stream(big_hit_noise)
        else:
            play_stream(small_hit_noise)
    )
