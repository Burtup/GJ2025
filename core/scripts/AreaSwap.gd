extends Node
# AreaSwap.gd

# ruta editable desde el editor; pon la .tscn que vayas a usar
@export_file("*.tscn") var target_scene_path: String = "res://PlatformerEvent.tscn"

func _ready() -> void:
	# conectar señal en runtime (alternativa: conectar desde el editor)
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# mejor usar grupos para detectar al jugador
	if body.is_in_group("player"):
		if FileAccess.file_exists(target_scene_path):
			get_tree().change_scene_to_file(target_scene_path)
		else:
			push_error("AreaSwap: escena objetivo no encontrada: %s" % target_scene_path)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
