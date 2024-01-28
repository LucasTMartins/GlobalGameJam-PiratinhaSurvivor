extends RigidBody2D

const SPEED = 3

var velocity = Vector2(0, 0)
var is_batalhando : bool = false
var player
var ultimo_local_player : Vector2
var state : int = 0
var vida : int = 3
#var ponto_parada : Vector2 = position
#var is_ponto_parada : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0 #desativando gravidade
	$TempoAndando.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if vida <= 0:
		queue_free()

func _physics_process(_delta):
	if is_batalhando:
		ir_ultimo_local_player()
	move_and_collide(velocity)
		

func _on_area_2d_body_entered(body):
	if body.is_in_group("jogador"):
		player = body
		$TempoAcao.start()

func _on_area_2d_body_exited(body):
	if body.is_in_group("jogador"):
		is_batalhando = false
		$TempoBusca.start()
		velocity = SPEED * ultimo_local_player

func _on_tempo_acao_timeout():
	$TempoAcao.stop()
	is_batalhando = true


func _on_tempo_busca_timeout():
	$TempoBusca.stop() #começando busca
	parar()
	#setar_ponto_parada()
	$TempoStandBy.start() #começando standby


func _on_tempo_stand_by_timeout():
	$TempoStandBy.stop()
	@warning_ignore("narrowing_conversion")
	state = randf_range(1, 5) #aleatorizando a direção
	#is_ponto_parada = false
	ir_direcao_aleatoria()

func parar():
	velocity = Vector2(0, 0)
	move_and_collide(velocity)

#func setar_ponto_parada():
	#ponto_parada = get_position()
	#is_ponto_parada = true
	
func ir_ultimo_local_player():
	if position.direction_to(player.get_position()) != Vector2(0, 0):
		ultimo_local_player = position.direction_to(player.get_position())
	velocity = SPEED * position.direction_to(player.get_position())

#func ir_ponto_parada():
	#is_ponto_parada = true
	#velocity = SPEED * ponto_parada
	#print("ponto parada", ponto_parada)
	#print("Posicao", get_global_transform_with_canvas().origin)
	#move_and_collide(velocity)
	#parar()
	#$TempoStandBy.start()

func ir_direcao_aleatoria():
	#Right
	if state == 1:
		$TempoAndando.start()
		velocity.x = SPEED
	#Left
	elif state == 2:
		$TempoAndando.start()
		velocity.x = -SPEED
	#Forward
	elif state == 3:
		$TempoAndando.start()
		velocity.y = SPEED
	#Back
	elif state == 4:
		$TempoAndando.start()
		velocity.y = -SPEED


func _on_tempo_andando_timeout():
	$TempoAndando.stop() #começando busca
	parar()
	$TempoStandBy.start() #começando standby

func atualiza_vida(dano):
	vida -= dano
