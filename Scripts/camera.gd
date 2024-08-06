extends Node3D

@onready var player: NodePath

@onready var player_node: Node3D = get_node(player)

var camera_offset: Vector3 = Vector3(0, 10, -10)

func _process(delta: float) -> void:
	if player_node:
		global_transform.origin = player_node.global_transform.origin + camera_offset
		look_at(player_node.global_transform.origin, Vector3.UP)
