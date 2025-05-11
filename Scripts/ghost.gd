extends Enemies

#@export var chanceOfSpecialAbility: float = 0.2 #randf() < chance

@export var distanceToHide: int = 200
var invisibilityDuration: float

var canHide: bool
var isInvisible: bool = false
var usedInvisibility: bool = false

@export var minInvisibilityDuration: float = 1.5
@export var maxInvisibilityDuration: float = 4.0

var invisibiltyTimer: Timer

@export_range(0.0, 1.0) var targetTransparency: float = 1.0

func _ready() -> void:
	super()

	await enemy_ready

	canMove = true

	#Make the shader material unique
	sprite.material = sprite.material.duplicate()

	#apply the damage and health
	hitBox.damage = damageFactor * 1
	healthComponent.health = healthFactor * 3.0
	
	#Decide whether it can be invisible
	canHide = randf() < chanceOfSpecialAbility
	if canHide:
		invisibilityDuration = randf_range(minInvisibilityDuration, maxInvisibilityDuration)
		invisibiltyTimer = Timer.new()
		invisibiltyTimer.wait_time = invisibilityDuration
		invisibiltyTimer.one_shot = true
		add_child(invisibiltyTimer)
		invisibiltyTimer.timeout.connect(make_visible)
	

func _process(_delta: float) -> void:
	if not isMutant: 
		if sprite.animation != "run":
			canMove = false
		else:
			canMove = true
	
	#Set the transparency
	var mat: ShaderMaterial = sprite.material
	# var currentTransparency = mat.get_shader_parameter("transparency")
	# var newTransparency = lerp(currentTransparency, targetTransparency, delta * fadeSpeed)

	mat.set_shader_parameter("transparency", targetTransparency)

	#Hide it 
	if canHide:
		if global_position.distance_to(player.global_position) <= distanceToHide and not usedInvisibility:
			make_invisible()
			invisibiltyTimer.start()
	

func _on_hit_box_attacked() -> void:
	queue_free()


func make_invisible():
	isInvisible = true
	usedInvisibility = true
	var hurtBoxCollision = hurtBox.get_node("CollisionShape2D") as CollisionShape2D
	hurtBoxCollision.disabled = true
	fade_out()

func make_visible():
	isInvisible = false
	var hurtBoxCollision = hurtBox.get_node("CollisionShape2D") as CollisionShape2D
	hurtBoxCollision.disabled = false
	fade_in()

func set_transparency(value: float):
	targetTransparency = clamp(value, 0.1, 1.0)

func fade_in():
	set_transparency(1.0)

func fade_out():
	set_transparency(0.3)
