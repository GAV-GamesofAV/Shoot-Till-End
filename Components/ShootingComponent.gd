extends Node
class_name ShootingComponent

@export var bulletScene: PackedScene
@export var shootingPoint: Marker2D
@export var fireRate: float
@export var sfxPlayer: AudioStreamPlayer
@export var shakeScreen: bool
@export var shakeIntensity: float
@export var shakeRotationIntensity: float

var cooldown: float
var cooldownTimer: Timer

func _ready() -> void:
	if not Global.gameOver:
		#Setup fire rate
		await Global.game_ready
		
		while not fireRate:
			var tree = get_tree()
			if not tree: 
				tree = get_tree()
			else :
				if tree:
					await tree.process_frame

		cooldown = 1.0 / fireRate
		cooldownTimer = Timer.new()
		add_child(cooldownTimer)
		cooldownTimer.wait_time = cooldown
		cooldownTimer.one_shot = true
		cooldownTimer.autostart = true

	
func shoot():
	if not Global.gameOver:
		if cooldownTimer.is_stopped():
			var bullet = bulletScene.instantiate()
			get_tree().current_scene.add_child(bullet)
			bullet.global_position = shootingPoint.global_position
			bullet.global_rotation = shootingPoint.global_rotation
			bullet.direction = Vector2.RIGHT.rotated(shootingPoint.global_rotation)
			cooldownTimer.start()

			if sfxPlayer:
				sfxPlayer.pitch_scale = randf_range(0.7, 1.3)
				sfxPlayer.play()
			
			if shakeScreen:
				get_tree().current_scene.shake_camera(shakeIntensity, shakeRotationIntensity)
