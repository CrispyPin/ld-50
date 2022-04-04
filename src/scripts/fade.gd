extends Control

export var start_delay := 1
export var in_speed := 0.1
export var end_delay := 16
export var out_speed := 0.01

var time := 0.0

func _ready():
	modulate.a = 0

func _process(delta):
	time += delta
	if time > end_delay:
		modulate.a = max(modulate.a - out_speed, 0)
	elif time > start_delay:
		modulate.a = min(modulate.a + in_speed, 1)
