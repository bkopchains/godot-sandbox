class_name Room

var coords: Vector2
var type: String
var doors: Dictionary
var rooms: Dictionary

func _init(type: String, coords: Vector2):
	self.coords = coords
	self.type = type
	self.doors = {
		"north": null,
		"south": null,
		"east": null,
		"west": null
	}
	self.rooms = {
		"north": null,
		"south": null,
		"east": null,
		"west": null
	}
