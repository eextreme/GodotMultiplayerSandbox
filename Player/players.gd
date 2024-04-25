extends CharacterBody2D
class_name Player

var name_id
const SPEED = 300.0
var controller : bool
@export var animated_sprite : AnimatedSprite2D
@export var healthBar : ProgressBar
@export var manaBar : ProgressBar

func _ready():
	$PlayerActionSynchronizer.set_multiplayer_authority(str(name).to_int())
	$PlayerStatusIndicator/StatusSynchronizer.set_multiplayer_authority(str(name).to_int())
	$Melee_attack/AttackSynchronizer.set_multiplayer_authority(str(name).to_int())
	
	if $PlayerActionSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	
	controller = $PlayerActionSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

@export var syncPos : Vector2
@export var syncFrame : int

func _process(delta):
	syncPos = global_position
	syncFrame = animated_sprite.frame

func takeDamage(amount):
	var newValue = healthBar.value-amount
	var tween = create_tween()
	tween.tween_property(healthBar,"value",newValue,1)

#@export var state = "idle"
#
#func _physics_process(delta):
	#if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		#$Camera2D.global_position = global_position
	## Add the gravity.
		#var directionX = Input.get_axis("ui_left","ui_right")
		#var directionY = Input.get_axis("ui_down","ui_up")
			#
		#if Input.is_action_just_pressed("attack"):
			#playback.travel("Cast")
			#animTree.set("parameters/Cast/blend_position",faceIdle)
#
		#if abs(directionX)>0:
			#velocity.x = directionX * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
		#
		#if abs(directionY)>0:
			#velocity.y = -directionY * SPEED
		#else:
			#velocity.y = move_toward(velocity.x, 0, SPEED)
		#
		#if abs(directionX)>0 or abs(directionY)>0:
			#state = "run"
			#playback.travel("Run")
			#faceIdle = Vector2(directionX,directionY)
			#animTree.set("parameters/Run/blend_position",Vector2(directionX,directionY))
			##animTree.set("parameters/playback",true)
			#move_and_slide()
		#elif velocity == Vector2.ZERO and state!="idle":
			#state = "idle"
			#playback.travel("Idle")
			#animTree.set("parameters/conditions/running",false)
			#animTree.set("parameters/Idle/blend_position",faceIdle)
	#else:
		#if state=="idle" and playback.get_current_node()!="Idle":
			#playback.travel("idle")
		#elif state =="run" and playback.get_current_node()!="Run":
			#playback.travel("run")
		

		
