extends Node2D

func play(audio_player: AudioStreamPlayer2D, pitches: Array = []):
	var audio_pitches = [0.9, 1.0, 1.1]
	if pitches and pitches.size() > 0:
		audio_pitches = pitches

	audio_player.pitch_scale = audio_pitches.pick_random()
	audio_player.play()
