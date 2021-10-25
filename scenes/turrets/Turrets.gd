extends Node2D


var enemy_array: Array = []
var built: bool = false
var enemy: Node2D
var type: String


func _ready() -> void:
	if built:
		var diameter: float = GameData.tower_data[type].range
		$Range/CollisionShape2D.get_shape().radius = diameter / 2 


func turn() -> void:
	get_node("Turret").look_at(enemy.position)


func select_enemy() -> void:
	var enemy_progress_array: Array = []
	for enemy in enemy_array:
		enemy_progress_array.append(enemy.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]


func _physics_process(delta) -> void:
	if built and enemy_array.size() > 0:
		select_enemy()
		turn()
	else:
		enemy = null


func _on_Range_body_entered(body) -> void:
	enemy_array.append(body.get_parent())


func _on_Range_body_exited(body) -> void:
	enemy_array.erase(body.get_parent())
 
