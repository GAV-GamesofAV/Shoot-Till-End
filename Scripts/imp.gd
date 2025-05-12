extends Enemies


@onready var shootingComponent: ShootingComponent = $ShootingComponent
@export var shootingPoint: Marker2D

var canShoot: bool

@export var distanceToShoot: int = 300
var isShooting: bool = false
var fireRate: float
var maxFireRate: float = 5
var minFireRate: float = 0.5

func _ready():
	super()
	await enemy_ready

	sprite.play("fly")
	canMove = true

	#Implement the damage
	hitBox.damage = damageFactor * 3.0
	healthComponent.health = healthFactor * 5.0

	#Special ability

	canShoot = randf() < chanceOfSpecialAbility
	if canShoot:
		fireRate = Global.level / 3.0
		fireRate = clamp(fireRate, minFireRate, maxFireRate)
		shootingComponent.fireRate = fireRate
		



func _process(_delta: float) -> void:
	if Global.gameReady:
		#Shooting mechanism
		if canShoot:
			if global_position.distance_to(player.global_position) <= distanceToShoot:
				canMove = false
				shoot()
			else:
				canMove = true

func shoot():
	var directionToPlayer: Vector2 = (player.global_position - shootingPoint.global_position).normalized()
	shootingPoint.rotation = directionToPlayer.angle()
	shootingComponent.shoot()

func hurt_animation_finished():
	sprite.play("fly")

func _on_hit_box_attacked() -> void:
	queue_free()
