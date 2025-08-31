extends KinematicBody2D
class_name Enemy


const Explosion = preload("res://Scenes/ExplosionParticles.tscn")

const ACC = 8

var path = []
var spd       = 0
var path_node = 0
var health    = 1
var moveSpd = 30.0
var navigation

export (Resource) var resource = preload("res://Resources/Skely.tres")

onready var sprite     = $Sprite
onready var animPlayer = $AnimationPlayer
onready var walkParticles = $WalkParticles
onready var walkSound = $WalkSounds
onready var goal = $"../../Goal"

signal i_made_it()
signal i_am_dead()


func _ready():
	navigation = get_tree().current_scene.find_node("Navigation2D")
	update_stats()
	
	var hud = get_tree().current_scene.find_node("Hud")
	if hud != null:
		connect("i_made_it", hud, "update_hp")

func update_stats():
	moveSpd = resource.movespd
	health = resource.health
	sprite.texture = resource.texture

func _physics_process(delta):
	if path_node < path.size() and global_position.distance_to(goal.global_position) > 8:
		play_anim("Run")
		walkParticles.emitting = true
		spd = lerp(spd, moveSpd, ACC * delta)
		
		var direction = path[path_node] - global_position
		
		if direction.length() < 1:
			path_node += 1
		else:
# warning-ignore:return_value_discarded
			move_and_slide(direction.normalized() * moveSpd)
	else:
		play_anim("Idle")
		walkParticles.emitting = false
		spd = 0

func request_path(target_position):
	if global_position.distance_to(target_position) <= 16:
		emit_signal("i_made_it")
		queue_free()
	
	path = navigation.get_simple_path(global_position, target_position)
	path_node = 0

func die():
	health -= 1
	moveSpd += 10
	var explosion = Explosion.instance()
	add_child(explosion)
	explosion.global_position = global_position + Vector2(0, -8)
	explosion.emitting = true
	if health <= 0:
		get_tree().reload_current_scene()
#	emit_signal("i_am_dead")
#	queue_free()

func play_sound():
	walkSound.pitch_scale = rand_range(1, 1.5)
	walkSound.play()

func play_anim(anim):
	if animPlayer.current_animation != anim:
		animPlayer.play(anim)

func _on_Timer_timeout():
	if navigation != null:
		request_path(goal.global_position)
