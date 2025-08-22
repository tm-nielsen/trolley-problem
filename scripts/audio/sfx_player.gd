class_name SFX_Player
extends AudioStreamPlayer3D

func bind_noise(bound_signal, bound_stream: AudioStream) -> void:
    bound_signal.connect(play_stream.bind(bound_stream))

func play_stream(new_stream: AudioStream) -> void:
    stream = new_stream
    play()