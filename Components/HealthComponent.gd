extends Node
class_name HealthComponent

signal took_damage
signal healed
signal died

@export var health: float
@export var healthBar: ProgressBar

func _ready() -> void:
	healthBar.max_value = health
	healthBar.value = health

func heal(amount):
	health += amount
	healthBar.value = health
	healed.emit()

func damage(amount):
	health -= amount
	healthBar.value = health
	took_damage.emit()
	if health <= 0:
		died.emit()
