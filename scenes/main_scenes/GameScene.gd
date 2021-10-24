extends Node2D


var map_node: Node2D

var build_mode: bool = false
var build_valid: bool = false
var build_location: Vector2
var build_tile: Vector2
var build_type: String


func _ready() -> void:
	map_node = $Map1
	
	for button in get_tree().get_nodes_in_group("build_buttons"):
		button.connect("pressed", self, "initiate_build_mode", [button.get_name()])
	
func _process(delta) -> void:
	if build_mode:
		update_tower_preview()
		

func _unhandled_input(event: InputEvent) -> void:
	if build_mode:
		if event.is_action_released("ui_cancel"):
			cancel_build_mode()
		if event.is_action_released("ui_accept"):
			verify_and_build()
			cancel_build_mode()

func initiate_build_mode(tower_type: String) -> void:
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "T1"
	build_mode = true
	$UI.set_tower_preview(build_type, get_global_mouse_position(), GameData.colors.GREEN)
	
	
func update_tower_preview() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var tower_exclusion: TileMap = map_node.get_node("TowerExclusion")
	var current_tile: Vector2 = tower_exclusion.world_to_map(mouse_position)
	var tile_position: Vector2 = tower_exclusion.map_to_world(current_tile)
	
	if tower_exclusion.get_cellv(current_tile) == -1:
		$UI.update_tower_preview(tile_position, GameData.colors.GREEN)
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		$UI.update_tower_preview(tile_position, GameData.colors.RED)
		build_valid = false
		
		
func cancel_build_mode() -> void:
	build_mode = false
	build_valid = false
	$UI/TowerPreview.free()
	
	
func verify_and_build() -> void:
	if build_valid:
		var new_tower: Node2D = load("res://scenes/turrets/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower)
		map_node.get_node("TowerExclusion").set_cellv(build_tile, 5)

		

