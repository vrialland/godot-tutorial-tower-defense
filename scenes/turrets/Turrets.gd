extends Node2D


var enemy_array: Array = []
var built: bool = false
var enemy: Node2D
var type: String
var category: String
var ready: bool = true


func _ready() -> void:
	if built:
		var diameter: float = GameData.tower_data[type].range
		$Range/CollisionShape2D.get_shape().radius = diameter / 2
		
		
func _physics_process(delta) -> void:
	if built and enemy_array.size() > 0:
		select_enemy()
		if not $AnimationPlayer.is_playing():
			turn()
		if ready:
			fire()
	else:
		enemy = null
		
		
func fire():
	ready = false
	var data: Dictionary = GameData.tower_data[type]
	if category == "projectile":
		fire_gun()
	elif category == "missile":
		fire_missile()
	enemy.on_hit(data.damage)
	yield(get_tree().create_timer(data.rof), "timeout")
	ready = true
	
	
func fire_gun() -> void:
	$AnimationPlayer.play("Fire")
	
	
func fire_missile() -> void:
	pass


func turn() -> void:
	get_node("Turret").look_at(enemy.position)


func select_enemy() -> void:
	var enemy_progress_array: Array = []
	for enemy in enemy_array:
		enemy_progress_array.append(enemy.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]


func _on_Range_body_entered(body) -> void:
	enemy_array.append(body.get_parent())


func _on_Range_body_exited(body) -> void:
	enemy_array.erase(body.get_parent())
 
