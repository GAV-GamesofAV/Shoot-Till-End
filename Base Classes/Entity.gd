extends CharacterBody2D
class_name Entity

@export var healthComponent: HealthComponent
@export var speed: int
@export var sprite: AnimatedSprite2D
@export var hurtBox: HurtBox

func move(direction):
	if direction:
		velocity = direction * speed
		move_and_slide()
