extends Area2D
@export var offset: float = 50 # Qué tan por debajo del borde inferior de la cámara está
@onready var cam = $".."

func _on_body_entered(body: Node2D) -> void:
	print("Entro algo: ", body.name)
	
	if body.name == "Empanada":
		print("¡Empanada murió! 💀")
		body.queue_free()
