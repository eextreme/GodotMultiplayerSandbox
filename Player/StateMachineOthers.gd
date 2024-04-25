extends SimpleStateMachine
var playback : AnimationNodeStateMachinePlayback
#
func _ready():
	playback = animation_tree.get("parameters/playback")
	add_state("idle")
	add_state("run")
	add_state("cast")
	add_state("attack")
	call_deferred("set_state",states.idle)
	pass

var direction
var aimLocation : Vector2
@export var faceDir : Vector2

func _state_logic(delta):
	pass
	
func create_melee_attack():
	pass

func create_ranged_attack():
	pass

func _get_transitions(delta):
	match state:
		states.idle:
			pass
		
		states.run:
			pass
		
		states.cast:
			pass
		
		states.attack:
			pass	

func _enter_state(new_state, old_state):
	match new_state:
		states.run:
			playback.travel("Run")
		states.idle:
			playback.travel("Idle")
		states.cast:
			playback.travel("Cast")
		states.attack:
			$"../Melee_attack".visible = true
			$"../Melee_attack/AttackSprite".play("slash")
			$"../Melee_attack/CollisionPolygon2D".disabled = false
			playback.travel("Attack")
	pass

func _exit_state(old_state,new_state):
	match old_state:
		states.run:
			pass
	pass
