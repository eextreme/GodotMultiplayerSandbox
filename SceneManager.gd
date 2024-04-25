extends Node

@export var PlayerScene : PackedScene
@export var currentPlayer : CharacterBody2D
@export var enemyTimer : Timer
@export var enemySpawner : MultiplayerSpawner
var players : Array

func _ready():
	var index = 0 
	for i in GameManager.Players:
		currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index+=1
	
	players = get_tree().get_nodes_in_group("player")

var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	#GameManager.targetLocation = players[0].global_position
	#enemyMonitor()
	pass

func enemyMonitor():
	if multiplayer.is_server():
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.dead:
				enemy.queue_free()
		

func spawn_enemies():
	if multiplayer.is_server():
		var enemy = preload("res://Enemy/Flying eye/flyingEye.tscn").instantiate()
		enemy.global_position = GameManager.targetLocation + Vector2(100,100) + Vector2(rng.randi_range(-5,5)*100,rng.randi_range(-5,5)*100)
		%Enemies.add_child(enemy,true)
	else:
		return
	
	
func _on_timer_timeout():
	spawn_enemies.call_deferred()
	enemyTimer.start()
	pass # Replace with function body.
