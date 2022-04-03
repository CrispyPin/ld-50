extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (Texture) var texture
export (Image) var image

# number of cells XY
export var size = [200,100] 

# size of a single pixel XY
var pixel_size = [0,0]

# misleading
var screen_size = [0,0]

var image_changed = false


# Called when the node enters the scene tree for the first time.
func _ready():

    #TODO: make resolution of actual game board
    #var resolution=OS.get_window_size()
    #var resolution=get_viewport_rect().size
    #self.screen_size[0] = resolution.x;
    #self.screen_size[1] = resolution.y;
    
    self.texture = ImageTexture.new()
    
    self.screen_size = size
    
    self.pixel_size[0] = 4
    self.pixel_size[1] = 4


    image = Image.new()
    print(screen_size)
    print(pixel_size)
    #image.load("res://icon.png")
    image.create(screen_size[0],screen_size[1],false, Image.FORMAT_RGB8)

    image.fill(Color(0,0,0,1))
    
    print(image)
    

    _create_update_texture()
    
    print(texture)
    
    
    #pass # Replace with function body.
func _create_update_texture():
    texture.create_from_image(self.image)
    texture.flags = 0


func set_pixel(x: int, y: int, c: Color):
    image.lock()
    image.set_pixel(x, y, c)
    image.unlock()
    image_changed = true

 

func _process(_delta):
    #self.set_pixel ( rand_range(0,size[0]), rand_range(0,size[0]), Color(rand_range(0,1),rand_range(0,1),rand_range(0,1),1))
    pixel_size = [Global.settings["pixel_size"],Global.settings["pixel_size"]]
    if image_changed:
        _create_update_texture()
    
    update() #hack :)

func _set_texture(value):
    # If the texture variable is modified externally,
    # this callback is called.
    texture = value  # Texture was changed.
    update()  # Update the node's visual representation.

func _draw():
    var rect = Rect2(0,0,size[0]*pixel_size[0],size[1]*pixel_size[1])
    draw_texture_rect ( texture, rect, false)
    #draw_texture(texture, Vector2())
