extends Area2D
class_name Collectible

signal is_ready #Emitted when the Collectible class's _ready is done
signal collected # Emitted when the player enters
signal work_done #Emitted when the collectible's work is done


func _ready() -> void:
	monitoring = true
	collision_layer = 1
	collision_mask = 2 
	call_deferred("_deferred_ready")
	

func _deferred_ready():
	body_entered.connect(_on_body_entered)
	work_done.connect(_work_done)

	is_ready.emit()


func _on_body_entered(body:Node2D) -> void:
	if body is Character:
		collected.emit()
		hide()
		call_deferred("_disable_monitoring")


	
func _disable_monitoring():monitoring = false

func _work_done():queue_free()
