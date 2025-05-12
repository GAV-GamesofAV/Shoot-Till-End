extends Entity
class_name Character

@export var joystick: Node2D
@export var joystickThreshold: float = 0.3
@export var gunJoystick: Node2D

@export var gun: Guns

@export var shakeIntensity: float = 3.0
@export var shakeRotationIntensity: float = 1.5

func _ready() -> void:
	gun.joystick = gunJoystick

	healthComponent.died.connect(game_over)
	healthComponent.took_damage.connect(_took_damage)
	healthComponent.health = Global.playerHealth

func _physics_process(_delta: float) -> void:

	if Global.gameReady:
		var direction
		#Movement
		if not Global.isMobile:
			direction = Input.get_vector("Move Left", "Move Right", "Move Up", "Move Down")
		else:
			if joystick:
				if joystick.posVector.length() >= joystickThreshold:
					direction = joystick.posVector.normalized()
			 
		move(direction)

		var playArea = get_tree().get_first_node_in_group("PlayArea")
		position = position.clamp(Vector2(playArea.minX, playArea.minY), Vector2(playArea.maxX, playArea.maxY))
		

		if direction: 
			sprite.play("run")
		else:
			sprite.play("idle")
	
		if not Global.isMobile:
			if get_global_mouse_position().x > global_position.x:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
		else:
			if abs(gun.rotation) > PI / 2:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		
func game_over():
	Global.gameReady = false
	Global.gameOver = true
	get_tree().change_scene_to_packed(Global.mainMenuScene)

func _took_damage():
	get_tree().current_scene.shake_camera(shakeIntensity, shakeRotationIntensity)
