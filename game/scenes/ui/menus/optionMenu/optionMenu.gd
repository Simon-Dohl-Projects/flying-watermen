class_name OptionsMenu extends Control

signal back_pressed()

@onready var master_bus_id = AudioServer.get_bus_index("Master")
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var fullscreen_check_button: CheckButton = %FullscreenCheckButton

@export var has_background: bool = true
# saving data
var save_file_path: String = "user://save/"
var save_file_name: String = "OptionSave.tres"
var option_data: OptionData = OptionData.new()

func _ready():
	$TextureRect.visible = has_background
	visible = false
	verify_save_dirctory(save_file_path)
	load_saved_options()
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_id))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_id))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_id))
	var is_fullscree: bool = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	fullscreen_check_button.button_pressed = is_fullscree

func verify_save_dirctory(path: String):
	DirAccess.make_dir_absolute(path)

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(master_bus_id, value < 0.001)
	option_data.save_music = master_slider.value

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_id, value < 0.001)
	option_data.save_music = music_slider.value

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_id, value < 0.001)
	option_data.save_sfx = sfx_slider.value

func _on_fullscreen_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	option_data.is_save_fullscreen = fullscreen_check_button.button_pressed

func update_save_options_data():
	option_data.is_save_fullscreen = fullscreen_check_button.button_pressed
	option_data.save_master_sound = master_slider.value
	option_data.save_music = music_slider.value
	option_data.save_sfx = sfx_slider.value

func _on_reset_settings_button_pressed():
	option_data.reset_values()
	update_fullscreen(option_data.is_deafault_fullscreen)
	update_master_sound(option_data.deafault_master_sound)
	update_music_slider(option_data.deafault_music)
	update_sfx_slider(option_data.deafault_sfx)

func load_saved_options():
	if FileAccess.file_exists(save_file_path + save_file_name):
		option_data = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		update_fullscreen(option_data.is_save_fullscreen)
		update_master_sound(option_data.save_master_sound)
		update_music_slider(option_data.save_music)
		update_sfx_slider(option_data.save_sfx)

func update_master_sound(value: float):
	_on_master_slider_value_changed(value)
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_id))

func update_sfx_slider(value: float):
	_on_sfx_slider_value_changed(value)
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_id))

func update_music_slider(value: float):
	_on_music_slider_value_changed(value)
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_id))

func update_fullscreen(is_fullscreen: bool):
	_on_fullscreen_check_button_toggled(is_fullscreen)
	var is_fullscreen_update: bool = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	fullscreen_check_button.button_pressed = is_fullscreen_update

func _on_back_button_pressed():
	update_save_options_data()
	ResourceSaver.save(option_data, save_file_path + save_file_name)
	back_pressed.emit()

func _input(event: InputEvent) -> void:
	if is_visible_in_tree() and event.is_action_pressed("esc"):
		back_pressed.emit()
		get_viewport().set_input_as_handled()
