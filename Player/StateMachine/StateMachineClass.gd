extends Node
class_name SimpleStateMachine

@export var character : CharacterBody2D
@export var camera : Camera2D
@export var animation_player : AnimationPlayer
@export var current_state = "idle"
@export var animation_tree: AnimationTree

var state = null
var previous_state = null
var states={}

func _physics_process(delta):
	if state !=null:
		_state_logic(delta)
		var transition = _get_transitions(delta)
		if transition!=null:
			set_state(transition)

func _state_logic(delta):
	pass

func _get_transitions(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state,new_state):
	pass
	
func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state !=null:
		_exit_state(previous_state,new_state)
	if new_state!=null:
		_enter_state(new_state,previous_state)

func add_state(state_name):
	states[state_name] = states.size()
