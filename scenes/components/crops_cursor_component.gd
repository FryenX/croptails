class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

var corn_plant_scene = preload("res://scenes/objects/plants/corn.tscn")
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or DataTypes.Tools.PlantTomato:
			get_cell_under_mouse()
			add_crop()
			
func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position =  tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	#print("mouse position: ", mouse_position, "cell position: ", cell_source_id)
	#print("distance: ", distance)
	
func add_crop() -> void:
	if distance < 20.0:
		var tile_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
		if tile_id != -1:  # -1 means no tile at that cell
			var crop_instance: Node2D

			if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
				crop_instance = corn_plant_scene.instantiate() as Node2D
			elif ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
				crop_instance = tomato_plant_scene.instantiate() as Node2D
			else:
				return  # Tool not supported

			crop_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(crop_instance)

func remove_crop() -> void:
	if distance < 20.0:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
