extends Area2D
class_name EnemyBasic

@export var animation : AnimationPlayer
@export var hit : bool = false
@export var health: Enemy_Health_Bar

var speed = 500
var attack = 10
var defense = 5
var recoil = 50
var targetPosition : Vector2


func _ready():
	animation.play("move")
			
func _physics_process(delta):
	if abs(global_position-targetPosition)> Vector2(5,5) and !hit:
		global_position+= global_position.direction_to(targetPosition) * speed * delta
	else:
		print("waiting")

@rpc("any_peer","call_local")
func clearEnemy():
	queue_free()

func takeDamage(dmg,angle):
	hit = true
	var stagger = Vector2(recoil * cos(angle), -recoil * sin(angle))
	var newPos = global_position + stagger
	create_tween().tween_property(self,"global_position",newPos,0.5)
	health.takeDamage(dmg)

func _on_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(attack)
	pass # Replace with function body.

func _on_enemy_health_bar_dead():
	clearEnemy.rpc()
	pass # Replace with function body.

func _on_enemy_health_bar_recovered():
	hit = false
	pass # Replace with function body.
