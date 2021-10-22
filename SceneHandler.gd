extends Node


func _ready() -> void:
	$MainMenu/Margins/VBox/NewGame.connect("pressed", self, "on_new_game_pressed")
	$MainMenu/Margins/VBox/Quit.connect("pressed", self, "on_quit_pressed")


func on_new_game_pressed() -> void:
	$MainMenu.queue_free()
	var game_scene = load("res://scenes/main_scenes/GameScene.tscn").instance()
	add_child(game_scene)


func on_quit_pressed() -> void:
	get_tree().quit()
