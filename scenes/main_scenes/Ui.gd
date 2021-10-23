extends CanvasLayer


func set_tower_preview(tower_type: String, mouse_position: Vector2, color: Color) -> void:
	var drag_tower = load("res://scenes/turrets/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = color
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child($TowerPreview, 0)
	
	
func update_tower_preview(new_position: Vector2, color: Color):
	$TowerPreview.rect_position = new_position
	if $TowerPreview/DragTower.modulate != color:
		$TowerPreview/DragTower.modulate = color
