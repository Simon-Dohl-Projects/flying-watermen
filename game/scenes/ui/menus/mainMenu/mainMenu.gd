class_name MainMenu extends Control

signal options_pressed()

func _on_start_pressed() -> void:
	Globals.load_with_loading_screen(Globals.main_scene)

func _on_option_pressed() -> void:
	options_pressed.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_delete_save_pressed():
	Globals.delet_save()
