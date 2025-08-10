extends Control


signal textbox_closed
signal animation_finished
var is_defending
@export var enemy: Resource = null
# Called when the node enters the scene tree for the first time.

var current_player_health = 0
var current_enemy_health = 0
func _ready() -> void:
	set_health($EnemyPanel/EnemyData/ProgressBar,current_enemy_health,enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar,State.current_health,State.max_health)
	$Textbox.hide()
	$Actions.hide()
	display_text("La estatua te reta a un duelo")
	await textbox_closed
	display_text("Dale click en el botón de comer\nlo más rápido que puedas")
	await textbox_closed
	#display_text("También puedes sabotearlo para que no pueda comer por un periodo de tiempo o huir de la batalla si así lo prefiers")
	#await textbox_closed
	$Actions.show()
	
	
func enemy_attack():
	if is_defending:
		is_defending = false
	current_enemy_health = min(enemy.health,current_enemy_health + enemy.damage)
	set_health($EnemyPanel/EnemyData/ProgressBar,current_enemy_health,enemy.health)
	$Enemy/CPUParticles2D.emitting = true
	#await animation_finished
	if current_enemy_health == enemy.health:
		display_text("¡Empanadin ha perdido la batalla!")
		await get_tree().create_timer(2).timeout
		await textbox_closed
		get_tree().quit()
	
	

func set_health(progress_bar,health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "%d/%d" % [health,max_health]
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")


func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text
	$PlayerAnimation.play("enter")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_run_pressed() -> void:
	display_text("Huiste sano y salvo")
	await textbox_closed
	get_tree().quit()


func _on_attack_pressed() -> void:
	current_player_health = min(State.max_health,current_player_health + State.damage)
	set_health($PlayerPanel/PlayerData/ProgressBar,current_player_health,State.max_health)
	$Player/CPUParticles2D.emitting = true
	#await animation_finished
	if current_player_health == State.max_health:
		display_text("¡%s fue derrotado!" % enemy.name)
		#await get_tree().create_timer(2).timeout
		await textbox_closed
		get_tree().quit()
	 # Replace with function body.


func _on_timer_timeout() -> void:
	if !$Textbox.visible and current_player_health < State.max_health:
		enemy_attack()


func _on_defend_pressed() -> void:
	is_defending = true # Replace with function body.
