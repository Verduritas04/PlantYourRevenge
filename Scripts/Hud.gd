extends Label


const YouWin = preload("res://Scenes/YouWin.tscn")

export var health = 3

onready var blip = $AudioStreamPlayer


func _ready():
	text = str(health)

func update_hp():
	if health > 0:
		blip.play()
		health -= 1
		text = str(health)
		if health <= 0:
			var youWin = YouWin.instance()
			get_parent().add_child(youWin)
			get_parent().get_node("YSort").queue_free()
			get_parent().player = null
