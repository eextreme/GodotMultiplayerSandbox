extends Control

@export var Address = "192.168.5.256" #Your local machine IP address or 0.0.0.0 if using a server
@export var port = 8910
var peer
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(peer_connection_failed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
	pass # Replace with function body.

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port,4)
	
	if error!=OK:
		print("Cannot host: "+str(error))
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# this get called on the server and clients
func peer_connected(id):
	print("Player Connected " + str(id))

# this get called on the server and clients
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("player")
	for i in players:
		if i.name == str(id):
			i.queue_free()

# called only from clients
func connected_to_server():
	print("Connected to server!")
	SendPlayerInformation.rpc_id(1,$LineEdit.text,multiplayer.get_unique_id())

# called only from clients
func peer_connection_failed():
	
	print("Connection failed")

@rpc("any_peer")
func SendPlayerInformation(name,id):
	if !GameManager.Players.has(id):
		GameManager.Players[id]={
			"name": name,
			"id": id,
			"level": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name,i)

func _on_host_button_down():
	hostGame()
	SendPlayerInformation($LineEdit.text,multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(Address,port)
	
	if error!=OK:
		print("Cannot join: "+error)
		return

	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.

func _on_start_game_button_down():
	StartGame.rpc()
	pass # Replace with function body.



