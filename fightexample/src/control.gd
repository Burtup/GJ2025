extends Control


signal textbox_closed

@export var enemy: Resource = null
# Called when the node enters the scene tree for the first time.

var current_player_health = 0
var current_enemy_health = 0
func _ready() -> void:
	set_health($EnemyPanel/EnemyData/ProgressBar,enemy.health,enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar,State.current_health,State.max_health)
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$Textbox.hide()
	$Actions.hide()
	display_text("Una estatua ha aparecido")
	await textbox_closed
	$Actions.show()

func set_health(progress_bar,health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health,max_health]
	

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")


func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_run_pressed() -> void:
	display_text("Huiste sano y salvo")
	await textbox_closed
	get_tree().quit()


func _on_attack_pressed() -> void:
	current_enemy_health = max(0,current_enemy_health - State.damage)
	set_health($EnemyPanel/EnemyData/ProgressBar,current_enemy_health,enemy.health)
	 # Replace with function body.
