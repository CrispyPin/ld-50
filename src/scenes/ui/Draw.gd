extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (Texture) var texture setget _set_texture
# Called when the node enters the scene tree for the first time.
func _ready():
    var texture = ImageTexture.new()
    var image = Image.new()
    
    #image.load("res://icon.png")
    image.create(256,256,false, Image.FORMAT_L8)
    image.fill(Color(1,0,0,1))
    
    texture.create_from_image(image)
    self.texture = texture
    
    #pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _set_texture(value):
    # If the texture variable is modified externally,
    # this callback is called.
    texture = value  # Texture was changed.
    update()  # Update the node's visual representation.

func _draw():
    draw_texture(texture, Vector2())
