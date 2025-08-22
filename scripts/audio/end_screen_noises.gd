extends Node

@export var win_noise_player: AudioStreamPlayer
@export var lose_noise_player: AudioStreamPlayer

func _ready():
    GlobalSignalBus.game_won.connect(win_noise_player.play)
    GlobalSignalBus.game_timer_ended.connect(lose_noise_player.play)