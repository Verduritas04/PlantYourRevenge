extends Node2D


const Explosion = preload("res://Scenes/ExplosionParticles.tscn")

const REMOVABLE_TILES = [Vector2(13, 0), Vector2(14, 0), Vector2(15, 0), Vector2(16, 0)]

var coor = Vector2.ZERO

onready var tileMap       = $Navigation2D/TileMap
onready var detectionArea = $DetectionArea
onready var player        = $YSort/Player


func _input(event):
	if player != null:
		if event.is_action_pressed("ui_place"):
			if detectionArea.get_overlapping_bodies() == [] and detectionArea.get_overlapping_areas() == [] and !is_valid_tile(coor.x, coor.y, [Vector2(16, 6)]):
				tileMap.set_cell(coor.x, coor.y, 0, false, false, false, Vector2(13 + randi() % 4, 0))
				tileMap.update_dirty_quadrants()
				var explosion = Explosion.instance()
				add_child(explosion)
				explosion.global_position = detectionArea.global_position + Vector2(8, 8)
				explosion.emitting = true
				player.hiImATree.pitch_scale = rand_range(0.8, 1)
				player.hiImATree.play()
		elif event.is_action_pressed("ui_remove"):
			if detectionArea.get_overlapping_bodies() != [] and is_valid_tile(coor.x, coor.y, REMOVABLE_TILES):
				tileMap.set_cell(coor.x, coor.y, 0, false, false, false, Vector2(0, randi() % 4))
				tileMap.update_dirty_quadrants()
				var explosion = Explosion.instance()
				add_child(explosion)
				explosion.global_position = detectionArea.global_position + Vector2(8, 8)
				explosion.emitting = true
				player.chopChop.pitch_scale = rand_range(0.8, 1)
				player.chopChop.play()

func _ready():
	MusicManager.play_music("LevelMusic")

func _process(_delta):
	var mousePos = get_global_mouse_position()
	if player != null:
		mousePos.x = clamp(mousePos.x, player.global_position.x - 8 - player.PLANT_DISTANCE, player.global_position.x + player.PLANT_DISTANCE)
		mousePos.y = clamp(mousePos.y, player.global_position.y - 16 - player.PLANT_DISTANCE, player.global_position.y + player.PLANT_DISTANCE)
	
	coor = mousePos / 16
	coor.x = int(coor.x)
	coor.y = int(coor.y)
	
	detectionArea.global_position = coor * 16

func is_valid_tile(posX, posY, validTiles):
	for tiles in validTiles:
		if tiles == tileMap.get_cell_autotile_coord(posX, posY):
			return true
	return false
