extends Node2D

var javali = preload("res://javali.tscn")
var lobo = preload("res://lobo.tscn")
var rng = RandomNumberGenerator.new()
var local_spawn : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$CooldownMusic.start()
	$TimerSpawn.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_cooldown_music_timeout():
	$CooldownMusic.stop()
	$MusicaPrincipal.playing = true

func _on_timer_spawn_timeout():
	$TimerSpawn.stop()
	var javali_spawn = javali.instantiate()
	var lobo_spawn = lobo.instantiate()
	var local_player = $MainChar.position
	var tipo_inimigo : int = rng.randi_range(1, 3)
	var range = rng.randf_range(-500, 500)
	
	local_spawn = Vector2(local_player.x + range, local_player.y + range)
	
	print(tipo_inimigo)
	if tipo_inimigo == 1:
		javali_spawn.global_position = local_spawn
		add_child(javali_spawn)
	elif tipo_inimigo == 2:
		lobo_spawn.global_position = local_spawn
		add_child(lobo_spawn)
	$TimerSpawn.start()
