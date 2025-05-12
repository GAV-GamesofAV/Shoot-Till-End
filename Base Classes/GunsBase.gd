extends Node2D
class_name Guns

@export var joystick: Node2D

@export var sprite: Sprite2D
@export var shootingComponent: ShootingComponent
@export var playerGun: bool

func _ready() -> void:
	if playerGun:
		shootingComponent.fireRate = Global.playerFireRate
		
		
func _process(_delta: float) -> void:
	if playerGun and Global.gameReady and not Global.gameOver:
		#PC controls
		if not Global.isMobile:
			#Rotate
			look_at(get_global_mouse_position())
			if get_global_mouse_position().x > global_position.x: 
				sprite.flip_v = false
			else:
				sprite.flip_v = true
			
			#Shoot
			if Input.is_action_pressed("Shoot"):
				shootingComponent.shoot()
		else :
			#Mobile Controls
			if joystick:
				#Rotate
				rotation = joystick.angle
				

				if abs(rotation) > PI / 2:
					sprite.flip_v = true
				else:
					sprite.flip_v = false
				
				#Shoot
				if joystick.pressing:
					shootingComponent.shoot()

				
