extends Label

const species_names = {
	"tree_1": "oak tree",
	"tree_2": "birch tree",
	"flower_1": "flower",
}

var t = 0

func _ready():
	pass # Replace with function body.


func _process(delta):
	t += delta
	if t > 0.2:
		t = 0
		update_list()

func update_list():
	text = "Species:"
	for s in Global.species_alive:
		text += "\n"
		if s in species_names:
			text += species_names[s]
		else:
			text += s
		text += ": "
		if Global.species_alive[s]:
			text += "alive"
		else:
			text += "extinct"
