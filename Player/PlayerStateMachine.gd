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

@export var direction : Vector2
var aimLocation : Vector2
@export var faceDir : Vector2

func _state_logic(delta):
	
	if !character.controller:
		var test = $"../AnimationTree" as AnimationTree
		test.active = false
		return
	
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
	if !character.controller:
		return
	
	match state:
		states.idle:
			if abs(faceDir.x)>0.25 and abs(faceDir.y)>0.25:
				animation_tree.set("parameters/Idle/blend_position",Vector2(faceDir.x,-faceDir.y))
			
			if Input.is_action_just_pressed("attack"):
				return states.attack

			if Input.is_action_just_pressed("cast"):
				return states.cast
			
			if abs(character.velocity.x)>0 or abs(character.velocity.y)>0:
				return states.run
			
		states.run:
			if abs(faceDir.x)>0.25 and abs(faceDir.y)>0.25:
				animation_tree.set("parameters/Run/blend_position",Vector2(faceDir.x,-faceDir.y))
			
			if Input.is_action_just_pressed("attack"):
				return states.attack
			if Input.is_action_just_pressed("cast"):
				return states.cast
			
			if character.velocity==Vector2.ZERO:
				return states.idle
		
		states.cast:
			if abs(faceDir.x)>0.25 and abs(faceDir.y)>0.25:
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
			if abs(faceDir.x)>0.25 and abs(faceDir.y)>0.25:
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
	if !character.controller:
		return
	
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
	if !character.controller:
		return
	
	match old_state:
		states.run:
			pass
	pass
