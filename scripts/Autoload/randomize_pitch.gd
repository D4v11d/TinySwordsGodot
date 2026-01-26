extends Node2D

func play(audio_player: AudioStreamPlayer2D):
	var pitches := [0.9, 1.0, 1.1]
	audio_player.pitch_scale = pitches.pick_random()
	audio_player.play()
