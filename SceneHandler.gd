extends Node


func _ready() -> void:
	load_main_menu()


func on_new_game_pressed() -> void:
	$MainMenu.queue_free()
	var game_scene: Node = load("res://scenes/main_scenes/GameScene.tscn").instance()
	add_child(game_scene)
	game_scene.connect("game_finished", self, "unload_game")


func on_quit_pressed() -> void:
	get_tree().quit()
	
	
func unload_game(result: bool) -> void:
	$GameScene.queue_free()
	var main_menu: Node = load("res://scenes/ui/MainMenu.tscn").instance()
	add_child(main_menu)
	load_main_menu()
	
	
func load_main_menu() -> void:
	$MainMenu/Margins/VBox/NewGame.connect("pressed", self, "on_new_game_pressed")
	$MainMenu/Margins/VBox/Quit.connect("pressed", self, "on_quit_pressed")
