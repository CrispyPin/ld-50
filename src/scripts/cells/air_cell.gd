extends Cell


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name AirCell

# Called when the node enters the scene tree for the first time.

var _col: Color

func _init():
    self._col = Color(
        rand_range(0.9,1.0),
        rand_range(0.9,1.0),
        rand_range(0.9,1.0)
        )*1.0

func getId():
    return Id.AIR

func draw():
    return _col


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
