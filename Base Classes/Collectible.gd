extends Area2D
class_name Collectible

signal is_ready #Emitted when the Collectible class's _ready is done
signal collected # Emitted when the player enters
signal work_done #Emitted when the collectible's work is done
signal collected_done #Emitted when the _collected is completed inside collectibles

@export var duration: int

var timer: Timer #Disconnect the timeout when collected

func _ready() -> void:
	monitoring = true
	collision_layer = 1
	collision_mask = 2 

	timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true

	call_deferred("_deferred_ready")
	

func _deferred_ready():
	body_entered.connect(_on_body_entered)
	work_done.connect(_work_done)
	timer.timeout.connect(_work_done)

	collected.connect(_collected)

	add_child(timer)

	timer.start()
	is_ready.emit()


func _on_body_entered(body:Node2D) -> void:
	if body is Character:
		collected.emit()
		hide()
		call_deferred("_disable_monitoring")

#Overwrite this function in child script with super()
func _collected():
	timer.queue_free()
	call_deferred("_deferred_collected")

func _deferred_collected():
	collected_done.emit()

func _disable_monitoring():monitoring = false

func _work_done():queue_free()
