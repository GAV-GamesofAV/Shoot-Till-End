extends CharacterBody2D
class_name Entity

@export var healthComponent: HealthComponent
@export var speed: int
@export var sprite: AnimatedSprite2D
@export var hurtBox: HurtBox

var healingParticle: AnimatedSprite2D

func _ready() -> void:
	healthComponent.healed.connect(_healed)

func _healed():
	healingParticle = preload("res://Scenes/Particles/healing_particle.tscn").instantiate()
	add_child(healingParticle)

	await healingParticle.animation_finished
	healingParticle.queue_free()

func move(direction):
	if Global.gameReady and not Global.gameOver:
		if direction:
			velocity = direction * speed
			move_and_slide()
