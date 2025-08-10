extends CharacterBody2D

# --- Variables comunes ---
@export var speed := 400.0

# --- Variables para modo plataforma ---
@export var gravity := 600.0
@export var jump_force := -600.0
@export var max_fall_speed := 1000.0

# --- Modo de control ---
enum PlayerMode { TOP_DOWN, PLATFORM }
@export var start_mode: PlayerMode = PlayerMode.TOP_DOWN
var mode: PlayerMode

var anim: AnimatedSprite2D

func _ready():
	anim = $AnimatedSprite2D
	mode = start_mode

func _physics_process(delta):
	if mode == PlayerMode.TOP_DOWN:
		handle_top_down(delta)
	elif mode == PlayerMode.PLATFORM:
		handle_platform(delta)
		_update_animation()

func handle_top_down(_delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = direction.normalized() * speed
	move_and_slide()

func handle_platform(delta):
	# Movimiento horizontal
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction * speed

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	# Salto
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()

func _update_animation():
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if is_on_floor():
		if direction == 0:
			anim.play("idle")
		else:
			anim.play("run")
	else:
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")

	# Flip horizontal
	if direction != 0:
		anim.flip_h = direction < 0
