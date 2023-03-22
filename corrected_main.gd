extends Node


func _ready():
	if "--server" in OS.get_cmdline_args():
		print('Server started')
		server_init()
	else: client_init()

var multiplayer_peer = ENetMultiplayerPeer.new()
const PORT = 8000
const ADDRESS = "127.0.0.1"

func server_init():
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer

func client_init():
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	$MyID.text = "Player id: "+str(multiplayer.get_unique_id())

func _process(delta):
	# если это клиент, и он не наблюдающий
	if not multiplayer.is_server() and not $IsObserver.button_pressed:
		if Input.is_key_pressed(KEY_A): $Sprite.rotation_degrees -= 10
		if Input.is_key_pressed(KEY_D): $Sprite.rotation_degrees += 10
		rpc_id(1, "remote_rotate_on_server", $Sprite.rotation_degrees)
	
@rpc("any_peer")
func remote_rotate_on_server(rotation_degrees):
	rpc("remote_rotate_on_client", rotation_degrees)

@rpc
func remote_rotate_on_client(rotation_degrees):
	$Sprite.rotation_degrees = rotation_degrees


