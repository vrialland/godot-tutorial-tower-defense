extends CanvasLayer

var tower_range = 350


func set_tower_preview(tower_type: String, mouse_position: Vector2, color: Color) -> void:
	var drag_tower = load("res://scenes/turrets/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = color
	
	var range_texture: Sprite = Sprite.new()
	range_texture.position = Vector2(32, 32)
	var scaling: float = tower_range / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://assets/ui/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = color
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child($TowerPreview, 0)
	
	
func update_tower_preview(new_position: Vector2, color: Color):
	$TowerPreview.rect_position = new_position
	if $TowerPreview/DragTower.modulate != color:
		$TowerPreview/DragTower.modulate = color
		$TowerPreview/Sprite.modulate = color
