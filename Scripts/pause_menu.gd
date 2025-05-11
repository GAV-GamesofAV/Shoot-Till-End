extends CanvasLayer


func _on_resume_button_pressed() -> void:
    hide()
    get_tree().paused = false


func _on_restart_button_pressed() -> void:
    get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
    get_tree().change_scene_to_packed(Global.mainMenuScene)
