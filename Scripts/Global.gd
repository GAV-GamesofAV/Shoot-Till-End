extends Node

signal level_increased
signal scoreChanged
signal highScoreChanged

var isMobile: bool

var dataPath = "user://playerdata.res"

#Setting variables
var canVibrate: bool = false

#Max values
var maxLevel: int = 100
var maxPlayerHealth: float = 20.0
var maxPlayerDamage: float = 5.0
var maxPlayerFireRate: float = 15


#Base Values
var basePlayerHealth: float = 10.0
var basePlayerDamage: float = 0.5
var basePlayerFireRate: float = 5

#Max level tracker
var playerHealthMaxed: bool = false
var playerDamageMaxed: bool = false
var playerFireRateMaxed: bool = false




var level: int = 1
var xp: int = 0
var baseRequiredXP: int = 5000
var requiredXP: int
var requiredXpGrowthFactor: float = 1.3

var statPoints: int = 0

var player: Character

var _score: int
var _highScore: int

var tempScore: int 

var score: int = 0:
	set(value):
		_score = value
		scoreChanged.emit()
	get():
		return _score

var highScore: int = 0:
	set(value):
		_highScore = value
		highScoreChanged.emit()
	get():
		return _highScore

var playerDamage: float = 0.5
var playerHealth: float = 10.0
var playerFireRate: float = 0


var mainMenuScene: PackedScene
var mainGameScene: PackedScene
var upgradeScene: PackedScene
var settingsScene: PackedScene

func is_mobile():
	return OS.get_name() in ["Android", "iOS"]

func vibrate(duration: int = 500):
	if isMobile and canVibrate:
		Input.vibrate_handheld(duration)

func _ready() -> void:
	
	isMobile = is_mobile()

	mainMenuScene = preload("res://Scenes/main_menu.tscn")
	mainGameScene = preload("res://Scenes/main_game.tscn")
	upgradeScene = preload("res://Scenes/upgrade_menu.tscn")
	settingsScene = preload("res://Scenes/settings.tscn")

	load_data()

	level = clamp(level, 1, maxLevel)
	playerDamage = max(playerDamage, basePlayerDamage)
	playerHealth = max(playerHealth, basePlayerHealth)
	playerFireRate = max(playerFireRate, basePlayerFireRate)

	check_maxed_level_reached()

	calculate_required_xp()


func level_up():
	level += 1
	calculate_required_xp()
	statPoints += 3
	xp = 0
	level_increased.emit()

func calculate_required_xp():
	requiredXP = baseRequiredXP * pow(requiredXpGrowthFactor, level - 1)

func check_maxed_level_reached():
	if playerDamage >= maxPlayerDamage:
		playerDamageMaxed = true
	if playerHealth >= maxPlayerHealth:
		playerHealthMaxed = true
	if playerFireRate >= maxPlayerFireRate:
		playerFireRateMaxed = true

func save_data():
	var data: Data = Data.new()
	data.level = level
	data.xp = xp
	data.highScore = highScore
	data.statPoints = statPoints
	data.playerDamage = playerDamage
	data.playerHealth = playerHealth
	data.playerFireRate = playerFireRate
	data.musicVolume = AudioServer.get_bus_volume_linear(1)
	data.sfxVolume = AudioServer.get_bus_volume_linear(2)

	ResourceSaver.save(data, dataPath)

func load_data():
	if ResourceLoader.exists(dataPath):
		var data = ResourceLoader.load(dataPath) as Data
		level = data.level
		xp = data.xp
		highScore = data.highScore
		statPoints = data.statPoints
		playerDamage = data.playerDamage
		playerHealth = data.playerHealth
		playerFireRate = data.playerFireRate
		AudioServer.set_bus_volume_linear(1, data.musicVolume)
		AudioServer.set_bus_volume_linear(2, data.sfxVolume)
