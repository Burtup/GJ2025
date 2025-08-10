extends Area2D

@export var offset: float = 50 # Qué tan por debajo del borde inferior de la cámara está
@onready var cam = $".."

func _process(delta):
	# Mantener el área en el borde inferior de la cámara
	var cam_bottom = cam.position.y + (get_viewport_rect().size.y / 2)
	position.y = cam_bottom + offset
	position.x = cam.position.x  # Centrado horizontalmente con la cámara


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Empanada tocó la zona de muerte")
