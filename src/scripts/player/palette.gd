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

var button_resource = preload("res://scenes/PaletteBtn.tscn")
var cursor
onready var container = $VBoxContainer/HBoxContainer


func _ready():
	cursor = get_node("/root/Game/Cursor")
	$VBoxContainer/HBoxContainer/LayoutPlaceholder.queue_free()
	for name in palette_items:
		var btn = button_resource.instance()
		btn.text = name
		btn.connect("pressed", self, "_pressed_item", [palette_items[name]])

		# create image and fill it with the cell types colour
		var img = Image.new()
		img.create(24, 24, false, Image.FORMAT_RGB8)
		var cell = Cells.make_cell_from_id(palette_items[name])
		img.fill(cell.draw())

		# set as icon for the button
		var tex = ImageTexture.new()
		tex.create_from_image(img)
		btn.icon = tex

		container.add_child(btn)

func _pressed_item(id):
	cursor.cell_type = id
