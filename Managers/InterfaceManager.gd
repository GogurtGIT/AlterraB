extends Control

var mute_toggle = false

# Called when the node enters the scene tree for the first time.
func _ready():
	BuildManager.AbleToBuild = false
	print("Build Disabled")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$showWood/woodValue.text = str(GameManager.Wood)
	$showStone/stoneValue.text = str(GameManager.Stone)
	$showFood/foodValue.text = str(GameManager.Food)
	$showIron/ironValue.text = str(GameManager.Iron)
	$showPop/popValue.text = str(GameManager.AvaPopulation) + "/" + str(GameManager.MaxPopulation)
	$showPop2/popValue2.text = str(GameManager.MaxPopulation)
	if Input.is_action_just_pressed("murw") && !mute_toggle:
			$"../../../sounds/AudioStreamPlayer".stop()
			$"../../../sounds/AudioStreamPlayer3".stop()
			$"../../../sounds/AudioStreamPlayer4".stop()
			mute_toggle = true 
	else: if Input.is_action_just_pressed("murw") && mute_toggle == true:
			$"../../../sounds/AudioStreamPlayer".play()
			mute_toggle = false 
	pass


func _on_spawn_lumby_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnLumby()
	$"../../../sounds/AudioStreamPlayer2".play()
	pass # Replace with function body.


func _on_spawn_miner_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnStone()
	$"../../../sounds/AudioStreamPlayer2".play()
	pass # Replace with function body.


func _on_area_2d_area_entered(_area):
	BuildManager.AbleToBuild = false
	print("Build Disabled")
	pass # Replace with function body.


func _on_area_2d_area_exited(_area):
	BuildManager.AbleToBuild = true
	print("Build Enabled")
	pass # Replace with function body.


func _on_spawn_stock_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnStock() 
	$"../../../sounds/AudioStreamPlayer2".play()
	pass # Replace with function body.


func _on_spawn_iron_miner_2_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnIron()
	$"../../../sounds/AudioStreamPlayer2".play()

func _on_spawn_wall_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnWall()
	$"../../../sounds/AudioStreamPlayer2".play()

func _on_spawn_corner_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnCorner()
	$"../../../sounds/AudioStreamPlayer2".play()

func _on_spawn_orchad_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnOrch()
	$"../../../sounds/AudioStreamPlayer2".play()

func _on_spawn_granarty_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnGran()
	$"../../../sounds/AudioStreamPlayer2".play()

func _on_spawn_house_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnHouse()
	$"../../../sounds/AudioStreamPlayer2".play()

func _on_spawn_road_button_down():
	BuildManager.AbleToBuild = false
	BuildManager.SpawnRoad()
	$"../../../sounds/AudioStreamPlayer2".play()

func _on_audio_stream_player_finished():
	$"../../../sounds/AudioStreamPlayer3".play()
	print("looped music")


func _on_audio_stream_player_3_finished():
	$"../../../sounds/AudioStreamPlayer4".play()


func _on_audio_stream_player_4_finished():
	$"../../../sounds/AudioStreamPlayer".play()


func _on_button_button_down():
	GameManager.CurrentState = GameManager.State.DESTROY
	pass # Replace with function body.
