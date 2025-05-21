extends Collectible

var minHealingAmount: float = 4.0
var maxHealingAmount: float = Global.playerHealth #The static health player have

var healingAmount: float

func _ready() -> void:
    super()
    await is_ready
    Global.set_message("Health Healer Spawned!", 3.0)

func _collected():
    super()
    healingAmount = randf_range(minHealingAmount, maxHealingAmount)
    Global.player.healthComponent.heal(healingAmount)