extends Control

func _ready() -> void:
	Global.tempScore = Global.score

	
	#Manage xp
	Global.calculate_required_xp()

	Global.xp += Global.score
	if Global.xp >= Global.requiredXP:
		Global.level_up()

	$ScoreLabel.text = "Current Score : " + str(Global.tempScore)
	$HighScoreLabel.text = "Highest Score : " + str(Global.highScore)
	$LevelLabel.text = "Level : " + str(Global.level)

	#At last 
	Global.score = 0

func _on_quit_button_pressed() -> void:
	Global.save_data()
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(Global.mainGameScene)


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_packed(Global.settingsScene)


func _on_upgrade_button_pressed() -> void:
	get_tree().change_scene_to_packed(Global.upgradeScene)
