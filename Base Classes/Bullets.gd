extends Node2D
class_name Bullets

@export var speed: int
var direction: Vector2 = Vector2.RIGHT
var onscreen: VisibleOnScreenNotifier2D

@export var hitbox: HitBox

func _ready() -> void:
	if not Global.gameOver:
		onscreen = VisibleOnScreenNotifier2D.new()
		add_child(onscreen)
		onscreen.screen_exited.connect(_screen_exited)

		hitbox.attacked.connect(_attacked)

		z_index = 1001

		hitbox.damage = Global.playerDamage

func _process(delta: float) -> void:
	if Global.gameReady:
		position += direction * speed * delta

func _screen_exited():
	queue_free()

func _attacked():
	queue_free()
