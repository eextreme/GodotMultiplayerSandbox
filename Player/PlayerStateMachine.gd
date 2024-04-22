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
	
	aimLocation = character.get_global_mouse_position()
	faceDir = (aimLocation-character.global_position).normalized()
	
	camera.global_position = character.global_position
	
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	#if state == states.idle or state == states.run:
	
	if abs(direction.x)>0:
		character.velocity.x = direction.x * character.SPEED
	else:
		character.velocity.x = move_toward(character.velocity.x,0, character.SPEED)
	
	if abs(direction.y)>0:
		character.velocity.y = direction.y * character.SPEED
	else:
		character.velocity.y = move_toward(character.velocity.y,0, character.SPEED)
	
	character.move_and_slide()

func create_melee_attack():
	pass

func create_ranged_attack():
	pass

func _get_transitions(delta):
	match state:
		states.idle:
			animation_tree.set("parameters/Idle/blend_position",Vector2(faceDir.x,-faceDir.y))
			
			if Input.is_action_just_pressed("attack"):
				return states.attack

			if Input.is_action_just_pressed("cast"):
				return states.cast
			
			if abs(character.velocity.x)>0 or abs(character.velocity.y)>0:
				return states.run
			
		states.run:
			animation_tree.set("parameters/Run/blend_position",Vector2(faceDir.x,-faceDir.y))
			
			if Input.is_action_just_pressed("attack"):
				return states.attack
			if Input.is_action_just_pressed("cast"):
				return states.cast
			
			if character.velocity==Vector2.ZERO:
				return states.idle
		
		states.cast:
			animation_tree.set("parameters/Cast/blend_position",Vector2(faceDir.x,-faceDir.y))
			
			if Input.is_action_just_pressed("attack"):
				return states.attack

			if Input.is_action_just_pressed("cast"):
				return states.cast			
			
			if playback.get_current_node()=="Idle":
				return states.idle
			if playback.get_current_node()=="Run":
				return states.run
		
		states.attack:
			animation_tree.set("parameters/Attack/blend_position",Vector2(faceDir.x,-faceDir.y))
			
			if Input.is_action_just_pressed("attack"):
				return states.attack

			if Input.is_action_just_pressed("cast"):
				return states.cast
			
			if playback.get_current_node()=="Idle":
				return states.idle
			if playback.get_current_node()=="Run":
				return states.run

func _enter_state(new_state, old_state):
	match new_state:
		states.run:
			playback.travel("Run")
		states.idle:
			playback.travel("Idle")
		states.cast:
			playback.travel("Cast")
		states.attack:
			$"../Area2D".visible = true
			$"../Area2D/AnimatedSprite2D".play("slash")
			$"../Area2D/CollisionPolygon2D".disabled = false
			playback.travel("Attack")
	pass

func _exit_state(old_state,new_state):
	match old_state:
		states.run:
			pass
	pass
