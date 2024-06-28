extends Node3D



# Preload all objects
var LumberHut : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/lumber_hut.tscn")
var MinerHut : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/stoneMine.tscn")
var Granary : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/granary.tscn")
var StockPile : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/stockPile.tscn")
var IronWorks : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/ironMine.tscn")
var House : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/house.tscn")
var Wall : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/wall.tscn")
var CornerWall : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/cornerWall.tscn")
var Orchard : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/Orchard.tscn")
var Road : PackedScene = ResourceLoader.load("res://Other/Testing/testTSCN/structors/road.tscn")
var xd = preload("res://Sounds/343097__edsward__plopenhanced.wav")

# Allows ability to build, sets default spawnable 
var AbleToBuild : bool = false
var CurrentSpawnable : Node3D
var buildCD : int = 0
var buildCapCD : int = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if buildCD <= buildCapCD:
		buildCD += 1
	if GameManager.CurrentState == GameManager.State.BUILD: # Check if player is in building state 
		# Place a marker at the cursor of the placer and then a highlight of the building being placed
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(get_viewport().get_mouse_position()) 
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
		var PosCurse = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
		if PosCurse != null:
			CurrentSpawnable.position = Vector3(round(PosCurse.x), PosCurse.y, round(PosCurse.z)) # Build the buildings on a grid-like pattern
		if AbleToBuild && canAfford(CurrentSpawnable) && GameManager.AvaPopulation >= CurrentSpawnable.PopCost && buildCD >= buildCapCD: 
			if Input.is_action_just_released("LeftMouseClick"):
				print("Built Object")
				var obj := CurrentSpawnable.duplicate()
				var navMesh = get_tree().get_nodes_in_group("NavMesh")[0]
				navMesh.add_child(obj)
				obj.activeBuild = true
				TAXES(obj)
				obj.runSpawn()
				GameManager.AvaPopulation -= obj.PopCost
				obj.spawned = true
				obj.setCollision(false)
				obj.position = CurrentSpawnable.position
				# Add the building to the collision 
				get_tree().get_nodes_in_group("NavMesh")[0].bake_navigation_mesh(true)
				buildCD -= buildCapCD + 1
		# Unselect a object
		if Input.is_action_just_released("RightMouseClick"): # Unselect a selected object and end build mode
			CurrentSpawnable.queue_free()
			CurrentSpawnable = null
			GameManager.CurrentState = GameManager.State.PLAY
			
		if Input.is_action_just_released("Rotate"):
			CurrentSpawnable.rotation_degrees += Vector3(0, 90, 0) # Rotate object 90 degrees

	if GameManager.CurrentState == GameManager.State.DESTROY: # Set the state to destroy and delete any selected building
		if Input.is_action_just_released("LeftMouseClick"):
			var camera = get_viewport().get_camera_3d()
			var from = camera.project_ray_origin(get_viewport().get_mouse_position()) 
			var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
			var SpaceState = get_world_3d().direct_space_state
			var params = PhysicsRayQueryParameters3D.new()
			params.from = from
			params.to = to
			var result = SpaceState.intersect_ray(params)
			if result and result.collider.is_in_group("building"):
				print("Successfully Assassinated Building")
				result.collider.queue_free()

	pass
	
func canAfford(obj) -> bool: # Check if player has enough resources to buy a building
	if GameManager.Wood - obj.WoodCost < 0:
		return false 
	if GameManager.Stone - obj.StoneCost < 0:
		return false 
	if GameManager.Iron - obj.IronCost < 0:
		return false 
	if GameManager.Food - obj.FoodCost < 0:
		return false 
	return true
	
func TAXES(obj):
	GameManager.Wood -= obj.WoodCost
	GameManager.Stone -= obj.StoneCost
	GameManager.Iron -= obj.IronCost
	GameManager.Food -= obj.FoodCost
		
# Function for spawning each of the possible buildings 
func SpawnLumby():
	SpawnObject(LumberHut)
	
func SpawnStone():
	SpawnObject(MinerHut)
	

func SpawnStock():
	SpawnObject(StockPile)
	
func SpawnIron():
	SpawnObject(IronWorks)

func SpawnWall():
	SpawnObject(Wall)
	
func SpawnCorner():
	SpawnObject(CornerWall)

func SpawnOrch():
	SpawnObject(Orchard)

func SpawnGran():
	SpawnObject(Granary)

func SpawnHouse():
	SpawnObject(House)
	
func SpawnRoad():
	SpawnObject(Road)

# Place the object chosen 
func SpawnObject(obj):
	print("Placed!")
	if CurrentSpawnable != null: 
		CurrentSpawnable.queue_free()
	CurrentSpawnable = obj.instantiate()
	CurrentSpawnable.setCollision(true)
	get_tree().root.add_child(CurrentSpawnable)
	GameManager.CurrentState = GameManager.State.BUILD
