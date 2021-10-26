extends PathFollow2D


signal base_damage(damage)

var speed: int = 150
var hp: int = 1000
var base_damage: int = 21


onready var health_bar: TextureProgress = $HealthBar
onready var impact_area: Position2D = $Impact
var projectile_impact = preload("res://scenes/support/ProjectileImpact.tscn")


func _ready() -> void:
	randomize()
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)


func _physics_process(delta: float) -> void:
	if unit_offset == 1.0: # Tank is at the end of the path
		emit_signal("base_damage", base_damage)
		queue_free()
	move(delta)
	
	
func on_hit(damage: int) -> void:
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()


func impact() -> void:
	var x_pos: int = randi() % 31
	var y_pos: int = randi() % 31
	var new_impact: AnimatedSprite = projectile_impact.instance()
	new_impact.position = Vector2(x_pos, y_pos)
	impact_area.add_child(new_impact)
	
func move(delta: float) -> void:
	set_offset(get_offset() + speed * delta)
	health_bar.set_position(position - Vector2(30, 30))


func on_destroy() -> void:
	$KinematicBody2D.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
