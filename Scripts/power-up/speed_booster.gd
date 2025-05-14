extends Collectible

#Currently the increase will be random

var increasingFactor: float

var speedBoostTime: float

@export var minIncreaseFactor: float = 1.3
@export var maxIncreaseFactor: float = 2.0

@export var minSpeedBoostTime: float = 4.0
@export var maxSpeedBoostTime: float = 10.0

var speedBoostTimer: Timer

var progressBar: ProgressBar

func _ready() -> void:
	super()
	await is_ready
	if Global.gameReady and not Global.gameOver:
		collected.connect(_collected)

func _process(delta: float) -> void:
	if progressBar:
		progressBar.value = speedBoostTimer.time_left



func _collected():
	if Global.gameReady and not Global.gameOver:
		increasingFactor = randf_range(minIncreaseFactor, maxIncreaseFactor)
		#First convert the speed into float then multiply and convert into int
		Global.player.speed = int(float(Global.player.speed) * increasingFactor)

		speedBoostTime = randf_range(minSpeedBoostTime, maxSpeedBoostTime)

		speedBoostTimer = Timer.new()
		speedBoostTimer.wait_time = speedBoostTime
		speedBoostTimer.one_shot = true
		speedBoostTimer.autostart = true

		speedBoostTimer.timeout.connect(_time_out)

		add_child(speedBoostTimer)

		progressBar = get_tree().get_first_node_in_group("SpeedBoosterBar")
		progressBar.max_value = speedBoostTime
		progressBar.show()


func _time_out():
	Global.player.speed = int(float(Global.player.speed) / increasingFactor)
	progressBar.hide()
	queue_free()
