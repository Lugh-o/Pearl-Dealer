class_name PearlCleaning
extends Node2D

const dirt: PackedScene = preload("res://scenes/pearl_cleaning/dirt/dirt.tscn")
const shine: PackedScene = preload("res://scenes/pearl_cleaning/shine/shine.tscn")
const crack: PackedScene = preload("res://scenes/pearl_cleaning/crack/crack.tscn")
const matte: PackedScene = preload("res://scenes/pearl_cleaning/matte/matte.tscn")

@onready var brush: Sprite2D = $Brush
@onready var tape: Sprite2D = $Tape
@onready var polish: Sprite2D = $Polish
@onready var pearl: Sprite2D = $Pearl

var target_pos_brush: Vector2
var target_pos_tape: Vector2
var target_pos_polish: Vector2

var is_brush = false
var is_tape = false
var is_polish = false

func _ready() -> void:
	create_dirt()
	create_matte()
	create_crack()
	position_tools()
	for child in pearl.get_children():
		if child is Node:
			print("aaaaaaaaaaaaa")

func _process(delta: float) -> void:
	if is_brush:
		brush.position = get_global_mouse_position()
		target_pos_brush = Vector2(276, 633)
		
		var overlapping_areas = brush.get_child(1).get_overlapping_areas()
		# var pearl_children = pearl.get_children()

	else:
		brush.position = brush.position.move_toward(target_pos_brush, 1000 * delta)
		target_pos_brush = Vector2(276, 533)

	if is_tape:
		tape.position = get_global_mouse_position()
		target_pos_tape = Vector2(576, 633)
	else:
		tape.position = tape.position.move_toward(target_pos_tape, 1000 * delta)
		target_pos_tape = Vector2(576, 533)

	if is_polish:
		polish.position = get_global_mouse_position()
		target_pos_polish = Vector2(876, 633)
	else:
		polish.position = polish.position.move_toward(target_pos_polish, 1000 * delta)
		target_pos_polish = Vector2(876, 533)

func position_tools() -> void:
	target_pos_brush = Vector2(brush.position.x, 633)
	target_pos_tape = Vector2(tape.position.x, 633)
	target_pos_polish = Vector2(polish.position.x, 633)

func create_dirt() -> void:
	for i in range(randi_range(5, 10)):
		var dirtInstance = dirt.instantiate()
		dirtInstance.position.x = randi_range(-150, 150) 
		dirtInstance.position.y = randi_range(-150, 150)
		dirtInstance.rotate(randi_range(0,180))
		pearl.add_child(dirtInstance)

func create_crack() -> void:
	var crackInstance = crack.instantiate()
	crackInstance.position.x = randi_range(-150, 150) 
	crackInstance.position.y = randi_range(-150, 150)
	crackInstance.rotate(randi_range(0,180))
	pearl.add_child(crackInstance)

func create_matte() -> void:
	for i in range(randi_range(3, 5)):
		var matteInstance = matte.instantiate()
		matteInstance.position.x = randi_range(-150, 150) 
		matteInstance.position.y = randi_range(-150, 150)
		matteInstance.rotate(randi_range(0,180))
		pearl.add_child(matteInstance)


func _on_polish_button_down() -> void:	
	is_polish = true
	is_brush = false
	is_tape = false

func _on_tape_button_down() -> void:
	is_tape = true
	is_brush = false
	is_polish = false

func _on_brush_button_down() -> void:
	is_brush = true
	is_tape = false
	is_polish = false