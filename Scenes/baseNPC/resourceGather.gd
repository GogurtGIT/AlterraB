extends CharacterBody3D

enum Task {
	GETRES,
	SEARCH,
	DELIVER,
	WALK,
}

var CurrentTask = Task.SEARCH
var Hut
var HeldRes := 5
var runOnce := true

@onready var navagent : NavigationAgent3D = $NavigationAgent3D
@export var WalkSpeed : int = 2
@export var ResourceGenAmount := 0
@export_enum("tree", "stone", "iron") var resArray: String


func _ready():
	pass
	

func _process(_delta):
	match CurrentTask:
		Task.GETRES:
			if runOnce: 
				runOnce = false
				await get_tree().create_timer(2.0).timeout
				runOnce = true
				HeldRes = ResourceGenAmount
				CurrentTask = Task.DELIVER
			pass
		Task.SEARCH:
			var resources = get_tree().get_nodes_in_group(resArray) 
			var nearestResObj = resources[0]
			for i in resources:
				if i.position.distance_to(position) < nearestResObj.position.distance_to(position):
					nearestResObj = i
			navagent.set_target_position(nearestResObj.global_position)
			CurrentTask = Task.WALK
			pass
		Task.DELIVER:
			var stockpiles = get_tree().get_nodes_in_group("stockpile")
			if stockpiles.size() > 0:
				var nearestStockObj = stockpiles[0]
				for i in stockpiles:
					if i.spawned: 
						if i.position.distance_to(position) < nearestStockObj.position.distance_to(position):
							nearestStockObj = i
				navagent.set_target_position(nearestStockObj.get_node("SpawnPoint").global_position)
				CurrentTask = Task.WALK
			pass
		Task.WALK:
			if navagent.is_navigation_finished(): 
				if HeldRes == 0:
					CurrentTask = Task.GETRES
				else: 
					match resArray:
						"iron":
							GameManager.Iron += HeldRes
						"tree":
							GameManager.Wood += HeldRes
						"stone":
							GameManager.Stone += HeldRes
					HeldRes = 0 
					CurrentTask = Task.SEARCH
				return
			var targetpos = navagent.get_next_path_position()
			var dirge = global_position.direction_to(targetpos)
			velocity = dirge * WalkSpeed
			move_and_slide()
			pass
	$Label3D.text = str(CurrentTask)
	pass
