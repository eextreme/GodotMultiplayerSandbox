extends Node

@export var enemy : Area2D
@export var health : Enemy_Health_Bar

@onready var targetTimer : Timer = $targetTimer
var startValue = 100
@export var retargetDelay = 1.5
@export var speedBuffOnTimeout : int = 0
@export var attackBuffOnTimeout : int = 0
@export var defenseBuffOnTimeout : int = 0
@export var regenOnTimeout : int = 0

func _ready():
	targetTimer.wait_time = retargetDelay

func getTarget():
	var targets = get_tree().get_nodes_in_group("player")
	for target in targets:
		if target.healthBar.value <= startValue:
			enemy.targetPosition = target.global_position	

func time_out_buff():
	enemy.speed += speedBuffOnTimeout
	enemy.attack += attackBuffOnTimeout
	enemy.defense += defenseBuffOnTimeout
	health.value += regenOnTimeout

func _on_target_timer_timeout():
	getTarget()
	time_out_buff()
	$targetTimer.start()
	pass # Replace with function body.
