extends AudioStreamPlayer2D


func change_music(music_path):
	self.stop()
	self.stream = load(music_path)
	self.play()
