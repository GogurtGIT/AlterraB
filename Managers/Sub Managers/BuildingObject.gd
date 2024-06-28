extends Node3D


var objects : Array # Set Empty Array 
var activeBuild : bool # Set enabling building

# Cost for Buildings
@export var WoodCost : int
@export var StoneCost : int
@export var IronCost : int
@export var FoodCost : int
@export var PopCost : int
# Setting up Actor(Workers)
@export var SpawnActor : bool = true # Defaulted to true
@export var Actor : PackedScene # Attach worker to the building 
var currentActor 
# Population variables
@export var IncPopCap : bool = false
@export var IncPopAmt : int = 2
var spawned : bool 



func _ready(): # Called upon run 
	var areaM = get_node("StaticBody3D/Area3D") # Find area around the object and set it as a variable 
	areaM.area_entered.connect(_on_area_3d_area_entered)
	areaM.area_exited.connect(_on_area_3d_area_exited)
	pass # Connect the area signals here to detect between placed buildings & about to be placed buildings


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func runSpawn(): # Runs upon spawned
	if SpawnActor: # Editable in the building object itself, does nothing if disabled. DISABLE SPAWNACTOR IF THERE IS NO WORKER PLACED WITH THE BUILDING
		var actor = Actor.instantiate() # Variable for placing the worker 
		currentActor = actor
		get_tree().root.add_child(actor) # Placing the Worker 
		actor.global_position = $StaticBody3D/SpawnPoint.global_position # Set position to the buildings spawnpoint. KEEP ALL SPAWNPOINT PATHS IDENTICAL 
		actor.Hut = $StaticBody3D/SpawnPoint.global_position #Redundant? 
	if IncPopCap:
		GameManager.MaxPopulation += IncPopAmt
	
func runDespawn():
	if SpawnActor:
		currentActor.queue_free()
	GameManager.Population -= PopCost
	if IncPopCap:
		GameManager.Population -= IncPopAmt
	queue_free()
	pass
	
	
func _on_area_3d_area_entered(area): 
	BuildManager.AbleToBuild = false
	if activeBuild: 
		print("Prevent Stacking")
		objects.append(area)
		print(BuildManager.AbleToBuild)
		BuildManager.AbleToBuild = false
	pass # Prevents placing a building on another building by adding the area to an Array. 


func _on_area_3d_area_exited(area):
	if activeBuild: 
		objects.remove_at(objects.find(area))
		if(objects.size() <= 0):
			BuildManager.AbleToBuild = true
	pass # Reset able to build back to true if not within another area and clear the array

func setCollision(disabled : bool):
	$StaticBody3D/CollisionShape3D.disabled = disabled # Default abletobuild
