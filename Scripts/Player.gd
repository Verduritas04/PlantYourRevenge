extends KinematicBody2D


const Explosion = preload("res://Scenes/ExplosionParticles.tscn")

const MOVE_SPD = 180
const ACC = 8
const PLANT_DISTANCE = 32

var spd         = Vector2.ZERO
var inputVector = Vector2.ZERO
var dashVector  = Vector2.DOWN

onready var animPlay      = $AnimationPlayer
onready var walkParticles = $WalkParticles
onready var stepSound     = $WalkSounds
onready var dashSound     = $DashSounds
onready var chopChop      = $ChopChop
onready var hiImATree     = $HiImATree


func _input(event):
	if event.is_action_pressed("ui_dash"):
		var explosion = Explosion.instance()
		walkParticles.add_child(explosion)
		explosion.global_position = global_position + Vector2(0, -8)
		explosion.emitting = true
		spd = dashVector * MOVE_SPD * 5
		dashSound.play()

func _ready():
	randomize()

func _physics_process(delta):
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	
	if inputVector == Vector2.ZERO:
		animPlay.play("Idle")
		walkParticles.emitting = false
	else:
		animPlay.play("Run")
		walkParticles.emitting = true
		dashVector = inputVector
	
	spd.x = lerp(spd.x, inputVector.x * MOVE_SPD, ACC * delta)
	spd.y = lerp(spd.y, inputVector.y * MOVE_SPD, ACC * delta)
	
	spd = move_and_slide(spd)

func play_step_sound():
	stepSound.pitch_scale = rand_range(1, 1.5)
	stepSound.play()

func die():
	get_tree().reload_current_scene()
