class_name Map
extends Node2D

var tiles: Dictionary = {}
var doors: Dictionary = {}
var current_pos = Vector2();

var tile = preload("res://scenes/map/tile.tscn");
var sprite_door = "res://assets/textures/door.png";
var sprite_current = "res://assets/textures/map_current.png";
var sprite_notvisited = "res://assets/textures/map_notvisited.png";
var sprite_visited = "res://assets/textures/map_visited.png";

func add_room(room: Room):
	tiles[room.coords] = tile.instantiate();
	tiles[room.coords].position = room.coords * 8
	add_child(tiles[room.coords]);

func visit_room(room: Room):
	tiles[current_pos].texture = ImageTexture.create_from_image(Image.load_from_file(sprite_visited))
	tiles[room.coords].texture = ImageTexture.create_from_image(Image.load_from_file(sprite_current))
	current_pos = room.coords;

func add_door(room1: Room, room2: Room):
	var door_pos = room1.coords.lerp(room2.coords, 0.5);
	doors[door_pos] = tile.instantiate();
	doors[door_pos].position = door_pos * 8;
	doors[door_pos].texture = ImageTexture.create_from_image(Image.load_from_file(sprite_door))
	add_child(doors[door_pos])
