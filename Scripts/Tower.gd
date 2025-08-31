extends Area2D
class_name Tower


const FireBall  = preload("res://Scenes/FireBall.tscn")

onready var fireBallSound = $AudioStreamPlayer2D


func shoot(targetPos):
	var fireBall = FireBall.instance()
	get_parent().add_child(fireBall)
	fireBall.global_position = global_position + Vector2(0, -8)
	fireBall.direction = global_position.direction_to(targetPos)
	fireBall.look_at(targetPos)
	fireBallSound.play()


func _on_Timer_timeout():
	if get_overlapping_areas() != []:
		shoot(get_overlapping_areas()[0].get_parent().global_position)
	elif get_overlapping_bodies() != []:
		shoot(get_overlapping_bodies()[0].global_position)
