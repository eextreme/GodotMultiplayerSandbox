extends ProgressBar
class_name Enemy_Health_Bar

@export var sprite : Sprite2D
@export var hitRecovery : int = 0.5
@export var health : int
@onready var hitTimer : Timer = $hitTimer
signal dead
signal recovered
signal hit
# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = health
	value = health
	hitTimer.wait_time = hitRecovery
	pass # Replace with function body.

func _physics_process(delta):
	if value<=0:
		emit_signal("dead")

func takeDamage(dmg):
	$hitTimer.start()
	emit_signal("hit")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self,"value",value-dmg,0.5)
	tween.tween_property(sprite,"self_modulate",Color.RED,0.25)
	tween.set_parallel(false)
	tween.tween_property(sprite,"self_modulate",Color.WHITE,0.25)

func _on_hit_timer_timeout():
	emit_signal("recovered")
	pass # Replace with function body.
