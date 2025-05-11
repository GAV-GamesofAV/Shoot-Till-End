extends Area2D
class_name HurtBox

@export var healthComponent: HealthComponent

@export var parentIsEnemy: bool

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area:Area2D) -> void:
	if area is HitBox:
		if (parentIsEnemy and area.is_in_group("Player")) or not(parentIsEnemy and area.is_in_group("Enemies")):

			healthComponent.damage(area.damage)
			area.attacked.emit()
	
