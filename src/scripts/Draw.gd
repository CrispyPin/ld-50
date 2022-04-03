extends TextureRect

#var texture
var image

# number of cells XY
export var size = [200, 100]

# size of a single pixel XY
var pixel_size = [4, 4]

# misleading
var screen_size = [0,0]

var image_changed = false


func _ready():
	Global.connect("setting_changed", self, "_setting_changed")
	_setting_changed()
	get_viewport().connect("size_changed", self, "update_pixel_size")
	update_pixel_size()
	# TODO: make resolution of actual game board
#	var resolution = OS.get_window_size()
#	var resolution = get_viewport_rect().size
#	screen_size[0] = resolution.x;
#	screen_size[1] = resolution.y;

	self.texture = ImageTexture.new()

	self.screen_size = size
	print(screen_size)
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
	update() #hack :)


func update_pixel_size():
	var res = get_viewport().size
	var px = floor(res.x / size[0])
	var py = floor((res.y - 40)/ size[1])
	var new = max(min(px, py), 1)
	if new != pixel_size[0]:
		Global.set_setting("pixel_size", new)


func _set_texture(value):
	# If the texture variable is modified externally,
	# this callback is called.
	texture = value  # Texture was changed.
	update()  # Update the node's visual representation.


func _setting_changed():
	var v = Global.settings["pixel_size"]
	pixel_size = [v, v]
	print("set size to ", pixel_size)
#	rect_size.x = v * size[0]
#	rect_size.y = v * size[1]
#	rect_size = Vector2(v * size[0], v * size[1])
	rect_min_size = Vector2(v * size[0], v * size[1])
#	force_update_transform()
