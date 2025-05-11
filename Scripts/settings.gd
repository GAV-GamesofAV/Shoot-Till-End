extends Control

func _ready() -> void:

	$MusicSlider.value = AudioServer.get_bus_volume_linear(1)
	$SFXSlider.value = AudioServer.get_bus_volume_linear(2)
	$VibrateButton.button_pressed = Global.canVibrate

func _on_sfx_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_linear(2, value)


func _on_music_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_linear(1, value)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(Global.mainMenuScene)



func _on_reset_game_progress_button_pressed() -> void:
	Global.level = 1
	Global.xp = 0
	Global.highScore = 0
	Global.playerDamage = 0.5
	Global.playerHealth = 10.0
	Global.playerFireRate = 2
	Global.statPoints = 0


func _on_vibrate_button_pressed() -> void:
	Global.canVibrate = !Global.canVibrate
