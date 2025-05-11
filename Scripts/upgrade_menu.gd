extends Control

signal not_enough_stat_points

@onready var xpBar: ProgressBar = $XPbar
@onready var xpLabel: Label = $XPLabel

#Variables
var healthCost: int 
var damageCost: int
var fireRateCost: int

func _ready() -> void:
	not_enough_stat_points.connect(shake_stat_label)

	xpLabel.text = str(Global.xp) + "/" + str(Global.requiredXP)

	xpBar.max_value = Global.requiredXP
	xpBar.value = Global.xp

	calculate_upgrade_cost()
	disable_upgrade_buttons()

func calculate_upgrade_cost():
	healthCost = Global.playerHealth / 10
	damageCost = Global.playerDamage * 2
	fireRateCost = Global.playerFireRate / 2

	$StatLabel.text = "Stat Points Available : " + str(Global.statPoints)

	$Upgrades/DamageUpgradeButton.text = "Upgrade Damage - " + str(damageCost)
	$Upgrades/HealthUpgradeButton.text = "Upgrade Health - " + str(healthCost)
	$Upgrades/FireRateUpgradeButton.text = "Upgrade Fire Rate - " + str(fireRateCost)

	disable_upgrade_buttons()

func shake_stat_label():
	$StatLabel/AnimationPlayer.play("shake")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(Global.mainMenuScene)


func _on_health_upgrade_button_pressed() -> void:
	if not Global.playerHealthMaxed:
		if Global.statPoints >= healthCost:
			Global.playerHealth += 2.0
			Global.statPoints -= healthCost
			Global.check_maxed_level_reached()
			calculate_upgrade_cost()
		else:
			not_enough_stat_points.emit()



func _on_damage_upgrade_button_pressed() -> void:
	if not Global.playerDamageMaxed:
		if Global.statPoints >= damageCost:
			Global.playerDamage += 0.2
			Global.statPoints -= damageCost
			Global.check_maxed_level_reached()
			calculate_upgrade_cost()
		else:
			not_enough_stat_points.emit()



func _on_fire_rate_upgrade_button_pressed() -> void:
	if not Global.playerFireRateMaxed:
		if Global.statPoints >= fireRateCost:
			Global.playerFireRate += 1
			Global.statPoints -= fireRateCost
			Global.check_maxed_level_reached()
			calculate_upgrade_cost()
		else:
			not_enough_stat_points.emit()

func disable_upgrade_buttons():
	if Global.playerHealthMaxed:
		$Upgrades/HealthUpgradeButton.text = "Health is now maxed!"
	if Global.playerDamageMaxed:
		$Upgrades/DamageUpgradeButton.text = "Damage is now maxed!"
	if Global.playerFireRateMaxed:
		$Upgrades/FireRateUpgradeButton.text = "FireRate is now maxed!"