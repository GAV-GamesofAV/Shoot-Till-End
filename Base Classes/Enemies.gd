extends Entity
class_name Enemies

signal enemy_ready

@export var scorePoints: int
@export var hitBox: HitBox

var isMutant: bool
var chanceOfMutant: float
var maxChanceOfMutant: float = 0.05

var chanceOfSpecialAbility: float
var maxChanceofSpecial: float = 0.4

var damageFactor: float
var healthFactor: float
var maxDamageFactor: float = 5.0
var maxHealthFactor: float = 5.0

var player
var canMove: bool

func _ready() -> void:
	sprite.animation_finished.connect(hurt_animation_finished)

	healthComponent.took_damage.connect(_took_damage)
	healthComponent.died.connect(died)
	if sprite.sprite_frames.has_animation("run"):
		sprite.play("run")


	await get_tree().current_scene.mainGame_ready


	player = get_tree().get_first_node_in_group("Player")

	
	#Initialize the chance of special ability
	chanceOfSpecialAbility = Global.level / 100.0
	chanceOfSpecialAbility = min(chanceOfSpecialAbility, maxChanceofSpecial)

	#Determine the damage and health
	damageFactor = Global.level * 0.2 
	damageFactor = clamp(damageFactor, 1, maxDamageFactor)
	healthFactor = Global.level * 0.2
	healthFactor = clamp(healthFactor, 1, maxHealthFactor)
	

	#Initialize the chance of mutatn
	chanceOfMutant = Global.level / 1000.0
	chanceOfMutant = min(chanceOfMutant, maxChanceOfMutant)

	#Is mutant
	isMutant = randf() < chanceOfMutant
	if isMutant:
		scale = Vector2(1.5, 1.5)
		damageFactor *= 2.0
		healthFactor *= 2.0

	enemy_ready.emit()

func _physics_process(_delta: float) -> void:
	if player:
		var direction

		if canMove:
			direction = (player.global_position - global_position).normalized()
			move(direction)
	
		if player.global_position.x > global_position.x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	

func _took_damage():
	if sprite.animation == "hurt":
		sprite.frame = 0
	else:
		sprite.play("hurt")

func hurt_animation_finished():
	sprite.play("run")

func died():
	Global.score += scorePoints
	get_tree().current_scene.shake_camera(2.0, 1.0)
	queue_free()
