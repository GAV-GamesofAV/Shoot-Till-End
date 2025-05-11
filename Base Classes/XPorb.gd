extends Area2D

@export var expPoints: int

func _ready() -> void:
    body_entered.connect(_body_entered)

func _body_entered(body):
    if body is Character:
        Global.xp += expPoints
        queue_free()