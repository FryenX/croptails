extends Timer

@export var audio_stream_player_2D: AudioStreamPlayer2D
@export var min_wait_time: float = 5.0
@export var max_wait_time: float = 10.0

func _on_timeout() -> void:
	audio_stream_player_2D.play()

	wait_time = randf_range(min_wait_time, max_wait_time)
	start()
