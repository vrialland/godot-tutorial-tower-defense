extends CanvasLayer


onready var hp_bar: TextureProgress = $HUD/InfoBar/HBox/HP
onready var hp_bar_tween: Tween = $HUD/InfoBar/HBox/HP/Tween


func set_tower_preview(tower_type: String, mouse_position: Vector2, color: Color) -> void:
	var drag_tower = load("res://scenes/turrets/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = color
	
	var range_texture: Sprite = Sprite.new()
	range_texture.position = Vector2(32, 32)
	var scaling: float = GameData.tower_data[tower_type].range / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture: Texture = load("res://assets/ui/range_overlay.png")
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
		
		
func update_health_bar(base_health: int):
	hp_bar_tween.interpolate_property(hp_bar, "value", hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	if base_health >= 60:
		hp_bar.set_tint_progress(GameData.colors.GREEN)
	elif base_health >= 25:
		hp_bar.set_tint_progress(GameData.colors.ORANGE)
	else:
		hp_bar.set_tint_progress(GameData.colors.RED)


func _on_PausePlay_pressed() -> void:
	var tree: SceneTree = get_tree()
	var parent: Node = get_parent()
	if parent.build_mode:
		parent.cancel_build_mode()
	if tree.is_paused():
		tree.paused = false
	elif parent.current_wave == 0:
		parent.current_wave = 1
		parent.start_next_wave()
	else:
		tree.paused = true


func _on_SpeedUp_pressed() -> void:
	var parent: Node = get_parent()
	if parent.build_mode:
		parent.cancel_build_mode()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)
