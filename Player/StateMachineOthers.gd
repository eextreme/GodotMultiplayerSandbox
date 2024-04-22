extends SimpleStateMachine
@export var playback : AnimationNodeStateMachinePlayback

#Run when state machine loads. Create state with add_state(<state>)
func _ready():
	playback = animation_tree.get("parameters/playback")
	add_state("run")
	add_state("cast")
	add_state("idle")
	add_state("attack")
	call_deferred("set_state",states.idle)
	pass

#Always running 
func _state_logic(delta):
	#character.global_position = character.global_position.lerp(character.syncPos,0.5)
	#character.animated_sprite.frame = lerp(character.animated_sprite.frame, character.syncFrame,0.5)
	pass

#Always running in specific states
func _get_transitions(delta):
	pass

#Runs when entering the state
func _enter_state(new_state, old_state):
	
	pass

#Runs when leaving the state
func _exit_state(old_state,new_state):
	pass
