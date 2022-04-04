extends Control


const palette_items = {
	"Air": Cell.Id.AIR,
	"Stone": Cell.Id.STONE,
	"Sand": Cell.Id.SAND,
	"Dirt": Cell.Id.DIRT,
	"Water": Cell.Id.WATER,
	"Fire": Cell.Id.FIRE,
	"Lava": Cell.Id.LAVA,
}

const name_list = {
	Cell.Id.AIR: "Air",
	Cell.Id.WALL: "Wall",
	Cell.Id.STONE: "Stone",
	Cell.Id.DIRT: "Dirt",
	Cell.Id.WATER: "Water",
	Cell.Id.SAND: "Sand",
	Cell.Id.FISH: "Fish",
	Cell.Id.BIRD: "Bird",
	Cell.Id.KELP: "Kelp",
	Cell.Id.GRASS: "Grass",
	Cell.Id.TREE_1: "Oak",
	Cell.Id.TREE_2: "Birch",
	Cell.Id.FLOWER_1: "Flower",
    Cell.Id.FIRE: "Fire",
    Cell.Id.SMOKE: "Smoke",
	Cell.Id.WORM: "Worm",
	Cell.Id.LAVA: "Lava",
	Cell.Id.FUNGUS: "Fungus",
}

var button_resource = preload("res://scenes/PaletteBtn.tscn")
var cursor
onready var container = $VBoxContainer/HBoxContainer


func _ready():
	cursor = get_node("/root/Game/Cursor")
	cursor.connect("type_changed", self, "update_tooltip")
	update_tooltip()
	$VBoxContainer/HBoxContainer/LayoutPlaceholder.queue_free()
	for name in palette_items:
		var btn = button_resource.instance()
		btn.text = name
		btn.connect("pressed", self, "_pressed_item", [palette_items[name]])

		# create image and fill it with the cell types colour
#		var img = Image.new()
#		img.create(24, 24, false, Image.FORMAT_RGB8)
#		var cell = Cells.make_cell_from_id(palette_items[name])
#		img.fill(cell.draw())
#
#		# set as icon for the button
#		var tex = ImageTexture.new()
#		tex.create_from_image(img)
		btn.icon = image_tex_from_id(palette_items[name])

		container.add_child(btn)

func _pressed_item(id):
	cursor.cell_type = id

func update_tooltip():
	var id = cursor.cell_type
	$VBoxContainer/HBoxContainer/Panel/HBoxContainer/VBoxContainer/Icon.texture = image_tex_from_id(id)
	if id in name_list:
		$VBoxContainer/HBoxContainer/Panel/HBoxContainer/LabelType.text = name_list[id]
	else:
		$VBoxContainer/HBoxContainer/Panel/HBoxContainer/LabelType.text = "POV: you broke the game"


func image_tex_from_id(id, size=28):
	var img = Image.new()
	img.create(size, size, false, Image.FORMAT_RGB8)
	var cell = Cells.make_cell_from_id(id)
	img.fill(cell.draw())

	# set as icon for the button
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	return tex

