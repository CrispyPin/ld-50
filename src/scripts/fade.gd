extends Control

export var start_delay := 20
export var speed := 0.01

var time := 0.0

func _ready():
	pass

func _process(delta):
	time += delta
	if time > start_delay:
		modulate.a -= speed
