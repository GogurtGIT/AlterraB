extends Node


enum State{
	PLAY,
	BUILD,
	DESTROY
}

var CurrentState = State.PLAY

var Wood := 500
var Stone := 500
var Mana := 0 
var Food := 5
var Iron := 100

var Population : int = 20
var MaxPopulation : int = 40
var AvaPopulation : int = 20 
var count : int = 0
var Citizen : PackedScene
var Happiness := 1 
var spawnReady : bool = true
var setPopTimer : int = 180

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	count += 1 # Count 1 every frame
	if Population < MaxPopulation && Happiness > 0:
		spawnReady = false
		if count >= setPopTimer: # Establish a 3 second delay on population increase
			spawnReady = true
			Population += 1
			AvaPopulation += 1
			count -= 180 # Reset population increase timer 
	elif spawnReady && Happiness < 0:
		spawnReady = false 
		await get_tree().create_timer(3.0).timeout
		spawnReady = true
		if AvaPopulation > 0:
			AvaPopulation -= 1
	if count >= 181: # Prevent timer going above 181 
		count -= 181
	pass 
