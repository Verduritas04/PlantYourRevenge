extends AudioStreamPlayer2D


func _on_EmitSound_finished():
	queue_free()
