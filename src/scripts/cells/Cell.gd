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
    KELP,
    TREE,
}

func getId():
    return Id.AIR

# Called when the node enters the scene tree for the first time.
#func _ready():
#    pass # Replace with function body.

func has_nearby(cells, x: int, y: int, id) -> bool:
    for x in range(-1,2):
        for y in range(-1,2):
            if cells.get_cell(x,y).getId() == id:
                return true
    return false

func is_in_water(cells, x, y):
    return has_nearby(cells, x, y, Id.WATER)

func draw():
    return Color(0,0,0,1)
    
func update(cells, light, x: int, y: int):
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
