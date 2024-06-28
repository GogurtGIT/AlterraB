extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	var sizeVP = get_viewport().size
#	var posMouse = get_viewport().get_mouse_position()
#	if posMouse.x < 100:
#		position.x -= 1
#	elif posMouse.x > sizeVP.x - 100:
#		position.x += 1 
#
#
#
#	if Input.is_action_just_released("ZOOMIN"):
#		print("Down")
#		$playerCamera.global_position -= $playerCamera.global_transform.basis.z
#	if Input.is_action_just_released("ZOOMOUT"):
#		print("Up")
#		$playerCamera.global_position += $playerCamera.global_transform.basis.z
#
#
