extends Enemies

var canFly: bool
var flying: bool
@export var distanceForFlying: int = 100


func _ready() -> void:
	super()
	await enemy_ready

	canMove = true

	#Implement the health and damage
	hitBox.damage = damageFactor * 0.5
	healthComponent.health = healthFactor * 1.5


	#Decide whether it can fly or not
	canFly = randf() < chanceOfSpecialAbility

func _process(_delta):
	if Global.gameReady:
		if not isMutant:
			if sprite.animation == "run" or sprite.animation == "flying":
				canMove = true
			else:
				canMove = false

		if player:
			if canFly and global_position.distance_to(player.global_position) <= distanceForFlying and not flying:
				fly()
		

func _on_hit_box_attacked() -> void:
	queue_free()

func fly():
	flying = true
	sprite.animation_finished.connect(_charging_animation_finished)
	canMove = false
	sprite.play("charging")

func _charging_animation_finished():
	sprite.play("flying")
	canMove = true
	speed = 200
		
