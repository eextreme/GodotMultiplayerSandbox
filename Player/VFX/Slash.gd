extends Area2D

@export var faceDir : SimpleStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = atan2(faceDir.faceDir.x, -faceDir.faceDir.y)
	pass

func _on_animated_sprite_2d_animation_finished():
	visible = false
	$CollisionPolygon2D.disabled = true
	pass # Replace with function body.

@rpc("any_peer","call_local")
func killEnemy(area):
	area.dead = true

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		killEnemy.rpc_id(multiplayer.get_unique_id(),area)
	pass # Replace with function body.
