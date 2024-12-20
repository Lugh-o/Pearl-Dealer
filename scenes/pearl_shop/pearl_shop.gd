class_name PearlShop
extends Node2D

var current_dialogue_line = 0
var cypher_dialogues = []
var cypher_dialogues_filtered = []
var current_custumer_index = 0
var current_custumer_instance
var current_custumer
var custumer_array
var day = 1
var is_grumpy = true

const main_menu = preload("res://scenes/interfaces/main_menu/main_menu.tscn")
const main_scene = preload("res://scenes/main_scene/main_scene.tscn")
@onready var pearl_shop: PearlShop = $"."

@onready var title_label: RichTextLabel = $Title/TitleLabel
@onready var question_1_text: RichTextLabel = $Questions/Question1/RichTextLabel
@onready var question_2_text: RichTextLabel = $Questions/Question2/RichTextLabel
@onready var question_3_text: RichTextLabel = $Questions/Question3/RichTextLabel

@onready var player_dialogue_box: Node2D = $PlayerDialogueBox
@onready var player_dialogue_box_label: RichTextLabel = $PlayerDialogueBox/RichTextLabel

@onready var custumer_dialogue_box: Node2D = $CustumerDialogueBox
@onready var custumer_dialogue_box_label: RichTextLabel = $CustumerDialogueBox/RichTextLabel
@onready var custumer_dialogue_box_name_label: RichTextLabel = $CustumerDialogueBox/Name

@onready var custumers: Node2D = $Custumers
@onready var questions: Control = $Questions
@onready var trust: Control = $Trust
@onready var game_over: Node2D = $GameOver

@onready var eelton_john = preload("res://scenes/pearl_shop/custumers/eelton_john.tscn")
@onready var gilly_eilish = preload("res://scenes/pearl_shop/custumers/gilly_eilish.tscn")
@onready var marlin_monroe = preload("res://scenes/pearl_shop/custumers/marlin_monroe.tscn")
@onready var sharkira = preload("res://scenes/pearl_shop/custumers/sharkira.tscn")
@onready var whale_smith = preload("res://scenes/pearl_shop/custumers/whale_smith.tscn")

@onready var femmumble: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var mascmumble: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var cashreg: AudioStreamPlayer2D = $AudioStreamPlayer2D3


func _ready() -> void:
	custumer_array = [eelton_john, gilly_eilish, marlin_monroe, sharkira, whale_smith]
	custumer_array.shuffle()
	current_custumer_index = 0
	var dialogueJson = FileAccess.open("res://scenes/pearl_shop/dialog/cypher_dialog.json", FileAccess.READ)
	
	if dialogueJson:
		cypher_dialogues = JSON.parse_string(dialogueJson.get_as_text())
		dialogueJson.close()

	start_dialogue_by_day(randi_range(1, 3))
	send_next_custumer() 

func start_dialogue_by_day(day_number: int) -> void:
	cypher_dialogues_filtered = []
	var theme

	match day_number:
		1: 
			theme = "oceanCurrents"
			title_label.bbcode_text = "[center]Trustworthy clients will show familiarity with navigation and marine flows.[/center]"
		2: 
			theme = "rareResources"
			title_label.bbcode_text = "[center]Trustworthy clients will demonstrate knowledge about valuable and hard-to-obtain items.[/center]"
		3: 
			theme = "rumorsAndPlaces"
			title_label.bbcode_text = "[center]Trustworthy clients will remain calm and informed about mysterious events and locations.[/center]"

	for item in cypher_dialogues:
		if item["theme"] == theme:
			cypher_dialogues_filtered.push_back(item)

	question_1_text.bbcode_text = cypher_dialogues_filtered[0]["question"]
	question_2_text.bbcode_text = cypher_dialogues_filtered[1]["question"]
	question_3_text.bbcode_text = cypher_dialogues_filtered[2]["question"]

func _on_button_1_down() -> void:
	current_dialogue_line = 0
	custumer_dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	custumer_dialogue_box_label.bbcode_text = "[center]" + cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if Globals.trustworthy_custumers[current_custumer_instance.name] else "untrustworthy"] + "[/center]"
	custumer_dialogue_box_name_label.bbcode_text = current_custumer_instance.name

func _on_button_2_down() -> void:
	current_dialogue_line = 1
	custumer_dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	custumer_dialogue_box_label.bbcode_text = "[center]" + cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if Globals.trustworthy_custumers[current_custumer_instance.name] else "untrustworthy"] + "[/center]"
	custumer_dialogue_box_name_label.bbcode_text = current_custumer_instance.name

func _on_button_3_down() -> void:
	current_dialogue_line = 2
	custumer_dialogue_box.visible = true
	questions.visible = false
	trust.visible = true
	custumer_dialogue_box_label.bbcode_text = "[center]" + cypher_dialogues_filtered[current_dialogue_line]["answer"]["trustworthy" if Globals.trustworthy_custumers[current_custumer_instance.name] else "untrustworthy"] + "[/center]"
	custumer_dialogue_box_name_label.bbcode_text = current_custumer_instance.name

func _on_yes_button_down() -> void:
	if not Globals.trustworthy_custumers[current_custumer_instance.name]: 
		handle_game_over()
	else:
		player_dialogue_box_label.bbcode_text = "[center]" + cypher_dialogues_filtered[current_dialogue_line]["reply"]["trustworthy" if Globals.trustworthy_custumers[current_custumer_instance.name] else "untrustworthy"] + "[/center]"
		player_dialogue_box.visible = true
		trust.visible = false
		custumer_dialogue_box.visible = false
		#dismiss_customer()
		current_custumer_index += 1
		if current_custumer_index == 5:
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_packed(main_scene)

		cashreg.play()
		Globals.gamestate = 1
		Globals.money += Globals.pearl_price
		Globals.pearl_price = 100
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(main_scene)

func _on_no_button_down() -> void:
	if Globals.trustworthy_custumers[current_custumer_instance.name]: 
		is_grumpy = true

	player_dialogue_box_label.bbcode_text = cypher_dialogues_filtered[current_dialogue_line]["reply"]["trustworthy" if Globals.trustworthy_custumers[current_custumer_instance.name] else "untrustworthy"]
	player_dialogue_box.visible = true
	trust.visible = false
	custumer_dialogue_box.visible = false
	dismiss_customer()
	
func send_next_custumer() -> void:
	is_grumpy = false
	current_custumer_instance = custumer_array[current_custumer_index].instantiate()
	current_custumer_instance.position = Vector2(-200, 350)
	custumers.add_child(current_custumer_instance)

	var tween = create_tween()
	tween.tween_property(current_custumer_instance, "position", Vector2(544, 350), 1)
	await tween.finished

	player_dialogue_box.visible = false
	trust.visible = false 
	player_dialogue_box.visible = false
	questions.visible = true

func dismiss_customer() -> void:
	var tween = create_tween()
	tween.tween_property(current_custumer_instance, "position", Vector2(1552, 350), 1)
	await tween.finished
	if randi_range(1, 2) == 1:
		femmumble.play()
	else:
		mascmumble.play()
	
	current_custumer_index += 1

	if current_custumer_index == 5:
		Globals.gamestate = 1
		Globals.pearl_price = 100
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(main_scene)
	else:
		send_next_custumer()

func handle_game_over() -> void:
	current_custumer_instance.get_child(1).visible = true
	custumer_dialogue_box.visible = false
	player_dialogue_box.visible = false
	trust.visible = false 
	player_dialogue_box.visible = false
	questions.visible = false
	Globals.gamestate = 1
	Globals.pearl_price = 100
	Globals.crack_amount = 0
	Globals.tape_ammount  = 2
	Globals.money  = 100
	await get_tree().create_timer(3).timeout
	game_over.visible = true


func _on_button_button_down() -> void:
	get_tree().change_scene_to_packed(main_menu)
