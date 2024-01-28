extends CharacterBody2D

const SPEED = 400.0
const DANO = 1

var input_direction
var vida = 5
var target = position #posição ao clicar com o mouse
var is_seguindo_target : bool = false
var is_batalhando : bool = false #se ele estiver batalhando
var is_batalhando_perto : bool = false #se ele estiver batalhando de perto
var is_atacando : bool = false #se ele estiver atacando
var is_dashing : bool = false   #se estiver no meio  de um dash
var is_charging_dash : bool = false   #se estiver recarregando um dash
var can_dash :bool = true #pode dar dash
var is_andando :bool = false #está andando
var direcao_olhando : Vector2
#var intervalo_ataque = 0.5 #Tempo em segundos entre cada ataque

func _process(_delta):
	if Input.is_action_just_pressed("zui_interact"):
		dash()
		
	if is_dashing:
		velocity = direcao_olhando * SPEED * 4
		move_and_slide()
		#animar_dash()
		$ColisaoBatalha.disabled = true
	else:
		$ColisaoBatalha.disabled = false
	
	if is_andando:
		animar_passos()
	
	var animacao = $AtaqueCorporal/ColisaoAtaqueC/AnimatedSprite2D
	var colisao = $AtaqueCorporal/ColisaoAtaqueC
	if is_atacando:
		
		colisao.disabled = false
		
		if direcao_olhando.y > 0.2: #frente
			colisao.position = Vector2(0, 100)
			animacao.play("Ataque_frente")
		if direcao_olhando.y < -0.2:
			colisao.position = Vector2(0, -100)
			animacao.play("Ataque_atras")
		if direcao_olhando.x > 0 and direcao_olhando.y < 0.2 and direcao_olhando.y > -0.2:
			colisao.position = Vector2(100, 0)
			animacao.flip_h = false
			animacao.play("Ataque_lado")
		if direcao_olhando.x < 0 and direcao_olhando.y < 0.2 and direcao_olhando.y > -0.2:
			colisao.position = Vector2(-100, 0)
			animacao.flip_h = true
			animacao.play("Ataque_lado")
	else:
		colisao.disabled = true
		animacao.stop()

func _physics_process(_delta):
	movimentar()

func _input(event):
	if event.is_action_pressed("zui_click"): #setando alvo para andar
		target = get_global_mouse_position()
		is_seguindo_target = true

func dash():
	if is_batalhando and can_dash:
		is_dashing = true
		can_dash = false
		$DashingTimer.start()

func movimentar():
	if !is_dashing:
		if is_seguindo_target:
			input_direction = position.direction_to(target)
			get_direcao_olhando(input_direction)
			is_andando = true
			velocity = input_direction * SPEED
			if position.distance_to(target) > 10:
				move_and_slide()
			else:
				is_seguindo_target = false
				is_andando = false
		else:
			#movimentar()
			input_direction = Input.get_vector("zui_left", "zui_right", "zui_up", "zui_down")
			get_direcao_olhando(input_direction)
			velocity = input_direction * SPEED
			is_andando = true
			move_and_slide()

func atacar():
	$AtackingTimer.start()
	is_atacando = true
	animar_ataque()
	#$AtaqueCorporal/ColisaoAtaqueC/AnimatedSprite2D.visible = false

func _on_dashing_timer_timeout():
	$DashingTimer.stop()
	is_dashing = false
	velocity = Vector2(0, 0)
	is_charging_dash = true
	$ChargingDashTimer.start()

func _on_charging_dash_timer_timeout():
	$ChargingDashTimer.stop() 
	is_charging_dash = false
	can_dash = true

func _on_cooldown_ataque_timeout():
	$CooldownAtaque.stop()
	if is_batalhando_perto:
		atacar()

func _on_atacking_timer_timeout():
	$AtackingTimer.stop()
	is_atacando = false
	$CooldownAtaque.start()

func _on_area_ataque_distancia_body_entered(body):
	if body.is_in_group("inimigos"):
		is_batalhando = true
		#print("batalhando")

func _on_area_ataque_distancia_body_exited(body):
	if body.is_in_group("inimigos"):
		is_batalhando = false	 
		#print("interagindo")
		
func _on_area_ataque_coporal_body_entered(body):
	if body.is_in_group("inimigos"):
		is_batalhando_perto = true
		atacar()

func _on_area_ataque_coporal_body_exited(body):
	if body.is_in_group("inimigos"):
		is_batalhando_perto = false
		
func _on_ataque_corporal_body_entered(body):
	if body.is_in_group("inimigos"):
		body.atualiza_vida(1)

func get_direcao_olhando(direcao):
	if direcao != Vector2(0, 0):
		direcao_olhando = direcao

func animar_passos():
	if direcao_olhando.y > 0.2:
		$AnimatedSprite2D.play("Andando_frente", -1)
	if direcao_olhando.y < -0.2:
		$AnimatedSprite2D.play("Andando_atras", -1)
	if direcao_olhando.x > 0 and direcao_olhando.y < 0.2 and direcao_olhando.y > -0.2:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("Andando_direita", -1)
	if direcao_olhando.x < 0 and direcao_olhando.y < 0.2 and direcao_olhando.y > -0.2:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("Andando_direita", -1)
	if velocity == Vector2(0, 0) and $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.stop()
		
func animar_ataque():
	var animacao = $AtaqueCorporal/ColisaoAtaqueC/AnimatedSprite2D
	
	if direcao_olhando.y > 0.2:
		animacao.visible = true
		animacao.play("Ataque_frente")
		#animacao.stop()
	if direcao_olhando.y < -0.2:
		animacao.visible = true
		animacao.play("Ataque_atras", -1)
		animacao.stop()
	if direcao_olhando.x > 0 and direcao_olhando.y < 0.2 and direcao_olhando.y > -0.2:
		animacao.visible = true
		animacao.flip_h = false
		animacao.play("Ataque_lado", -1)
		animacao.stop()
	if direcao_olhando.x < 0 and direcao_olhando.y < 0.2 and direcao_olhando.y > -0.2:
		animacao.visible = true
		animacao.flip_h = true
		animacao.play("Ataque_lado", -1)
		animacao.stop()
	
func atualiza_vida(dano):
	vida -= dano
		
#func animar_dash():
	#if direcao_olhando == Vector2 (0, 1):
		#$AnimatedSprite2D.play("Dash_frente", -1)
	#if direcao_olhando == Vector2 (0, -1):
		#$AnimatedSprite2D.play("Dash_atras", -1)
	#if direcao_olhando == Vector2 (1, 0):
		#$AnimatedSprite2D.flip_h = false
		#$AnimatedSprite2D.play("Dash_direita", -1)
	#if direcao_olhando == Vector2 (-1, 0):
		#$AnimatedSprite2D.flip_h = true
		#$AnimatedSprite2D.play("Dash_direita", -1)
	#if velocity == Vector2(0, 0) and $AnimatedSprite2D.is_playing():
		#$AnimatedSprite2D.stop()
