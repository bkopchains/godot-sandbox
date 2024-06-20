class_name Door
extends Sprite2D

var types: Array = ["a", "b", "c", "d", null]
var type = types[0];

func update_type(_type):
	type = _type;
	frame = types.find(type);
