extends Node2D
class_name Background

@export var minX: int
@export var minY: int
@export var maxX: int
@export var maxY: int

func _ready() -> void:
    add_to_group("Background")
