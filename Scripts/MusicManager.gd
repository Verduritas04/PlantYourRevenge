extends Node


const MenuMusic   = preload("res://Music/b423b42.ogg")
const LevelMusic =  preload("res://Music/the-hex-09.ogg")

onready var music = $Music


func play_music(song):
	match song:
		"None":
			music.stop()
		"LevelMusic":
			if music.stream != LevelMusic:
				music.stream = LevelMusic
				music.play()
		"Menu":
			if music.stream != MenuMusic:
				music.stream = MenuMusic
				music.play()
