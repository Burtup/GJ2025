extends Node2D

@export var platform_scene: PackedScene
@export var platform_count: int = 20
@export var min_gap: float = 60
@export var max_gap: float = 75
@export var level_width: float = 400
@onready var plataformas_container = $Plataformas

func _ready():
	var y = 0
	for i in range(platform_count):
		var platform = platform_scene.instantiate()
		var x = randf_range(0, level_width)
		y -= randf_range(min_gap, max_gap)
		platform.position = Vector2(x, y)
		plataformas_container.add_child(platform)
