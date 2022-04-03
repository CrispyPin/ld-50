extends Cell
class_name AirCell

var _col: Color

func _init():
    self._col = Color(
        rand_range(0.95,1.0),
        rand_range(0.95,1.0),
        rand_range(0.95,1.0)
        )*1.0

func getId():
    return Id.AIR

func draw():
    return _col
