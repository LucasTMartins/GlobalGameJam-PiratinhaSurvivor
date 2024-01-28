extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicaPrincipal.playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $MusicaPrincipal.playing == false:
		$MusicaPrincipal.playing = true
