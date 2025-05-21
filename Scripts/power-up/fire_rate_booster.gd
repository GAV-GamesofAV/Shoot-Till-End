extends Collectible

@export var minScaleDur: float = 3.0
@export var maxScaleDur: float = 6.0

@export var minScaleFactor: float = 1.2
@export var maxScaleFactor: float = 1.6

var scalingDuration: float
var scalingFactor: float

var durTimer: Timer

var bar: ProgressBar

func _ready() -> void:
    super()
    await is_ready
    Global.set_message("Fire Rate Booster Spawned", 3.0)

func _process(delta: float) -> void:
    if bar:
        bar.value = durTimer.time_left

func _collected():
    super()
    await collected_done
    
    #Set the scaling factor and duration
    scalingFactor = randf_range(minScaleFactor, maxScaleFactor)
    scalingDuration = randf_range(minScaleDur, maxScaleDur)

    #Boost
    Global.player.gun.shootingComponent.fireRate *= scalingFactor

    #Set the timer
    durTimer = Timer.new()
    durTimer.wait_time = scalingDuration
    durTimer.one_shot = true
    durTimer.autostart = true
    add_child(durTimer)

    durTimer.timeout.connect(_time_out)

    #Set the bar
    bar = get_tree().get_first_node_in_group("FireRateBoosterBar")
    bar.max_value = scalingDuration
    bar.show()

func _time_out():
    Global.player.gun.shootingComponent.fireRate /= scalingFactor
    bar.hide()
    work_done.emit()