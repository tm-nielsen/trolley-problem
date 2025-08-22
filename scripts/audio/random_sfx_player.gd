extends AudioStreamPlayer

@export var possible_streams: Array[AudioStream]

func play_random_stream():
    stream = possible_streams.pick_random()
    play()
