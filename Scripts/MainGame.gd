extends Node2D


#node references
@onready var enemySpawnLocation: PathFollow2D = $EnemySpawner/EnemySpawnLocation

@export var enemies: Array[PackedScene]

@export var powerUpScenes: Array[PackedScene]

#Exported variables

@export var baseMinSpawnTimer: float = 3.0
@export var baseMaxSpawnTimer: float = 5.0
@export var maxSpawnLimit: float = 1.5
@export var minSpawnLimit: float = 0.5

@export var minPowerUpSpawnTime: int = 10
@export var maxPowerUpSpawnTime: int = 20

#Variables
var playArea: Background

func _ready() -> void:
	get_tree().paused = false
	Global.gameReady = false
	$PauseMenu.hide()

	#Set-up mobile controls:
	if Global.isMobile:
		$UI/MobileControls.show()
	else :
		$UI/MobileControls.hide()

	Global.score = 0
	
	#Connect signals
	Global.scoreChanged.connect(_score_changed)

	#Clear the player group
	
	for child in get_tree().get_nodes_in_group("Player"): 
		child.remove_from_group("Player")
	
	#Add the character to Player group
	for child in get_children():
		if child.is_in_group("Characters"):
			child.add_to_group("Player")
			break
	
	#Add the Background node to its group
	# for child in get_tree().get_nodes_in_group("Background"):
	# 	child.remove_from_group("Background")
	
	for child in get_children():
		if child.is_in_group("Background") or child is Background:
			child.add_to_group("PlayArea")
			playArea = child
			break
 
	#Set tht player to Global player variable
	Global.player = get_tree().get_first_node_in_group("Player")

	$EnemySpawnTimer.timeout.connect(spawnEnemy)

	#Set-up bars
	$UI/Bars/SpeedBoostBar.hide()

	#Set-up power up spawn
	$PowerUpSpawnTimer.timeout.connect(spawn_power_up)
	start_power_up_spawn_timer()
	
	Global.game_ready.emit()
	Global.gameReady = true

	Global.gameOver = false
	

	if Global.gameReady:
		$EnemySpawnTimer.start()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$UI/PauseButton.pressed.emit()

func _score_changed():
	$UI/ScoreLabel.text = "Score : " + str(Global.score)

	if Global.score > Global.highScore:
		Global.highScore = Global.score

func get_spawn_interval():
	var scaleFactor = 1.0 + (Global.score / 500.0)
	var minTime = baseMinSpawnTimer / scaleFactor
	var maxTime = baseMaxSpawnTimer / scaleFactor

	#Clamp the values
	minTime = max(minTime, minSpawnLimit)
	maxTime = max(maxTime, maxSpawnLimit)

	return randf_range(minTime, maxTime)


func spawnEnemy():
	var enemyType = enemies[randi() % enemies.size()]
	var enemy = enemyType.instantiate()
	
	get_tree().current_scene.add_child(enemy)
	enemySpawnLocation.progress_ratio = randf()

	enemy.global_position = enemySpawnLocation.global_position

	$EnemySpawnTimer.wait_time = get_spawn_interval()
	$EnemySpawnTimer.start()

	if Global.gameReady:
		Global.game_ready.emit()


func start_power_up_spawn_timer():
	$PowerUpSpawnTimer.wait_time = randi_range(minPowerUpSpawnTime, maxPowerUpSpawnTime)
	$PowerUpSpawnTimer.start()
	
func spawn_power_up():
	
	var powerUp: Collectible = powerUpScenes[randi() % powerUpScenes.size()].instantiate()
	var pos: Vector2 = Vector2(
		randf_range(playArea.minX + 20, playArea.maxX - 20),
		randf_range(playArea.minY + 20, playArea.maxY - 20)
	)
	powerUp.position = pos
	add_child(powerUp)
	start_power_up_spawn_timer()


func shake_camera(intensity, rotationIntensity):
	$Camera2D.shake(intensity, rotationIntensity)



func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	$PauseMenu.show()




func _on_resume_button_pressed() -> void:
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	pass # Replace with function body.
