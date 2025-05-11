extends Camera2D

var shakeIntensity: float = 0.0
var shakeRotationIntensity: float = 0.0
var shakeDecay: float = 5.0

func _process(delta: float) -> void:
	if shakeIntensity > 0:
		#Position shake
		offset = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * shakeIntensity
	
		#Rotation intensity
		rotation = deg_to_rad(randf_range(-1, 1)) * shakeRotationIntensity

		#Decay
		shakeIntensity = lerp(shakeIntensity, 0.0, delta * shakeDecay)
		shakeRotationIntensity = lerp(shakeRotationIntensity, 0.0, delta * shakeDecay)
	else:
		offset = Vector2.ZERO
		rotation = 0

func shake(intensity, rotationIntensity):
	shakeIntensity = intensity
	shakeRotationIntensity = rotationIntensity
