extends SFX_Player

@export var paddle: PaddleController
@export var small_push_noise: AudioStream
@export var big_push_noise: AudioStream
@export var jumped_noise: AudioStream
@export var ground_noise: AudioStream


func _ready():
    paddle.pushed.connect(
        func(push_scale):
        if (abs(push_scale) < paddle.full_stroke_push_scale):
            play_stream(small_push_noise)
        else:
            play_stream(big_push_noise)
    )
    bind_noise(paddle.jumped, jumped_noise)
    bind_noise(paddle.hit_ground, ground_noise)