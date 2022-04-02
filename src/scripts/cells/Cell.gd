extends Object


# Declare member variables here. Examples:
# var a = 2
# var b = "text"




class_name Cell

enum Id {
    AIR,
    WALL,
    WATER,
    SAND,
    FISH,
    TREE,
}

func getId():
    return Id.AIR

# Called when the node enters the scene tree for the first time.
#func _ready():
#    pass # Replace with function body.



func draw():
    return Color(0,0,0,1)
    
func update(cells, x: int, y: int):
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
