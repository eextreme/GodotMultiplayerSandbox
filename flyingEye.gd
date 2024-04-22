extends Area2D

var players : Array
@export var animation : AnimationPlayer
var rng = RandomNumberGenerator.new()
var speed = 10
@export var rageTimer : Timer
@export var dead = false


func _ready():
	animation.play("move")
	var attackTween = create_tween()
	attackTween.tween_property(self,"global_position",GameManager.targetLocation,speed)
	animation.play("move")

func _process(delta):
	pass

func _on_timer_timeout():
	var tween = create_tween()
	if speed>0.5:
		speed*=0.5
	tween.tween_property(self,"global_position",GameManager.targetLocation,speed)
	rageTimer.start()
	pass # Replace with function body.


func _on_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(10)
	pass # Replace with function body.
