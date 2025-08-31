extends Position2D


const EnemyToSpawn = preload("res://Scenes/Enemy.tscn")

var enemyNumber

export (Array, Resource) var enemies = []
export (float) var intervalA = 1.0
export (float) var intervalB = 2.0
export (float) var startTime = 3.0

onready var startTimer = $StartTimer
onready var spawnTimer = $SpawnTimer


func _ready():
	enemyNumber = enemies.size()
	startTimer.start(startTime)

func spawn_enemy():
	if enemies != []:
		var enemy = EnemyToSpawn.instance()
		get_parent().add_child(enemy)
		enemy.global_position = global_position
		enemy.resource = enemies[0]
		enemy.update_stats()
		enemies.remove(0)

func _on_StartTimer_timeout():
	spawnTimer.start(rand_range(intervalA, intervalB))

func _on_SpawnTimer_timeout():
	spawn_enemy()
	spawnTimer.start(rand_range(intervalA, intervalB))
