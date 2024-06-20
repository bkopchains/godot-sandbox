extends Node2D
@onready var north_label = $north
@onready var south_label = $south
@onready var east_label = $east
@onready var west_label = $west
@onready var type_label = $type
@onready var door_north: Door = $"Door North"
@onready var door_south: Door = $"Door South"
@onready var door_east: Door = $"Door East"
@onready var door_west: Door = $"Door West"

@onready var n_select = $north/n_select
@onready var s_select = $south/s_select
@onready var e_select = $east/e_select
@onready var w_select = $west/w_select
@onready var map: Map = $Map

@export var map_max_distance = 10;

var game_room: Room;

# Function to generate a branching room map
func generate_branching_room_map(max_width: int) -> Dictionary:
	var room_map = {}
	var types = ["A", "B", "C", "D"]
	var door_types = ["a", "b", "c", "d"]
	var directions = ["north", "south", "east", "west"]

	# Initialize starting room
	var start_room = Room.new("starting", Vector2(0,0));
	room_map[Vector2(0, 0)] = start_room

	# Queue for BFS-like expansion
	var queue: Array = []
	queue.append(Vector2(0, 0))

	while queue.size() > 0:
		var current_pos = queue.pop_front()
		var current_room: Room = room_map[current_pos]
		map.add_room(current_room);

		# Randomly decide how many new rooms to create in random directions
		var num_new_rooms = randi() % (max_width + 1)

		for dir_index in range(4):
			# Randomly choose a direction to expand
			var make_room_chance = randi_range(0,10) <= 5
			var make_door_chance = randi_range(0,10) <= 2
			var direction = directions[dir_index]

			# Determine new room position
			var new_pos = current_pos
			match direction:
				"north":
					new_pos += Vector2(0, -1)
				"south":
					new_pos += Vector2(0, 1)
				"east":
					new_pos += Vector2(1, 0)
				"west":
					new_pos += Vector2(-1, 0)

			# Check if new position is not yet occupied and within max distance
			if (not room_map.has(new_pos)) and absf(Vector2(0,0).distance_to(new_pos)) <= max_width:
				if(make_room_chance):
					var new_type = types[randi() % types.size()]
					var new_room: Room = Room.new(new_type, new_pos)
					current_room.doors[direction] = door_types[randi() % door_types.size()]
					new_room.doors[get_opposite_direction(direction)] = current_room.doors[direction]
					map.add_door(current_room, new_room);
					
					current_room.rooms[direction] = new_room;
					new_room.rooms[get_opposite_direction(direction)] = current_room;
					
					room_map[new_pos] = new_room
					queue.append(new_pos)
				else:
					room_map[new_pos] = null;
					current_room.rooms[direction] = null;
			# If pointing at a space that already has a room, add a chance to build a door between them
			elif(room_map.has(new_pos) and room_map[new_pos] != null):
				if(make_door_chance):
					current_room.doors[direction] = door_types[randi() % door_types.size()]
					room_map[new_pos].doors[get_opposite_direction(direction)] = current_room.doors[direction]
					map.add_door(current_room, room_map[new_pos]);
					
					current_room.rooms[direction] = room_map[new_pos];
					room_map[new_pos].rooms[get_opposite_direction(direction)] = current_room;

	return room_map

# Function to get opposite direction
func get_opposite_direction(direction: String) -> String:
	match direction:
		"north": return "south"
		"south": return "north"
		"east": return "west"
		"west": return "east"
	return ""

func _unhandled_input(event):
	if(Input.is_action_just_pressed("up") and game_room.rooms["north"] != null):
		game_room = game_room.rooms["north"];
		n_select.play();
		update_room(game_room);
	if(Input.is_action_just_pressed("down") and game_room.rooms["south"] != null):
		game_room = game_room.rooms["south"];
		s_select.play();
		update_room(game_room);
	if(Input.is_action_just_pressed("left") and game_room.rooms["west"] != null):
		game_room = game_room.rooms["west"];
		w_select.play();
		update_room(game_room);
	if(Input.is_action_just_pressed("right") and game_room.rooms["east"] != null):
		game_room = game_room.rooms["east"];
		e_select.play();
		update_room(game_room);
		
	if(Input.is_key_pressed(KEY_R)):
		get_tree().reload_current_scene();

func _ready():
	var room_map = generate_branching_room_map(map_max_distance);
	game_room = room_map[Vector2(0,0)];
	update_room(game_room);
	
func update_room(room: Room):
	map.visit_room(room);
	
	north_label.text = room.doors["north"] if room.doors["north"] != null else "";
	door_north.update_type(room.doors["north"]);
	south_label.text = room.doors["south"] if room.doors["south"] != null else "";
	door_south.update_type(room.doors["south"]);
	east_label.text = room.doors["east"] if room.doors["east"] != null else "";
	door_east.update_type(room.doors["east"]);
	west_label.text = room.doors["west"] if room.doors["west"] != null else "";
	door_west.update_type(room.doors["west"]);
	type_label.text = room.type;
	
