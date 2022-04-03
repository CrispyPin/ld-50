extends TextureRect

# number of cells XY
export var size = [200, 100]
# size of a single pixel XY
var pixel_size := 4

var image
var image_changed = false

func _ready():
	Global.connect("setting_changed", self, "_setting_changed")
	_setting_changed()
	get_viewport().connect("size_changed", self, "update_pixel_size")
	update_pixel_size()

	self.texture = ImageTexture.new()
	print(size)
	print(pixel_size)

	image = Image.new()
	image.create(size[0], size[1], false, Image.FORMAT_RGB8)
	image.fill(Color(0,0,0,1))
	image.lock()
	_create_update_texture()


func _create_update_texture():
	texture.create_from_image(self.image, 0)


func set_pixel(x: int, y: int, c: Color):
	image.set_pixel(x, y, c)
	image_changed = true


func _process(_delta):
	if image_changed:
		_create_update_texture()


func update_pixel_size():
	var res = get_viewport().size
	var px = floor(res.x / size[0])
	var py = floor((res.y - 40)/ size[1])
	var new = max(min(px, py), 1)
	if new != pixel_size:
		Global.set_setting("pixel_size", new)


func _setting_changed():
	var v = Global.settings["pixel_size"]
	pixel_size = v
	print("Set pixel size to: ", pixel_size)
	rect_min_size = Vector2(v * size[0], v * size[1])
