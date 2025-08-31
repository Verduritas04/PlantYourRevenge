extends Area2D


const HitSound = preload("res://Scenes/EmitSound.tscn")
const hit = preload("res://SFX/Hit.wav")

const MOVE_SPD = 300

var direction = Vector2.RIGHT


func _process(delta):
	global_position += direction * MOVE_SPD * delta

func _on_FireBall_body_entered(body):
	if body.has_method("die"):
		body.die()
	hit_sound()
	queue_free()

func _on_FireBall_area_entered(area):
	if area.get_parent().has_method("die"):
		area.get_parent().die()
	hit_sound()
	queue_free()

func hit_sound():
	var hitSound = HitSound.instance()
	get_parent().add_child(hitSound)
	hitSound.global_position = global_position
	hitSound.stream = hit
	hitSound.play()
