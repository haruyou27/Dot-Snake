extends Area2D
class_name Food

var nutrient := 0
@onready var shape :CircleShape2D = $CollisionShape2D.shape

func _ready() -> void:
	shape.radius = nutrient

@rpc("call_local", "unreliable")
func eaten() -> void:
	queue_free()
