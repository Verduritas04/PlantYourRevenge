extends Button


export var level = "res://Scenes/Level1.tscn"


func _on_Button_pressed():
	get_tree().change_scene(level)
