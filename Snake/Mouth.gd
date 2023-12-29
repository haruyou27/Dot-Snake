extends RayCast2D
class_name SnakeMouth

func _ready() -> void:
	if not is_multiplayer_authority():
		return

func _physics_process(_delta) -> void:
	if not is_colliding():
		return
	var collider = get_collider()
	if collider is SnakeCollider:
		snake.rpc("die")
	elif collider is Food:
		snake.eat(collider.nutrient)
		collider.rpc("eaten")
	
@onready var snake :Snake = $".."
func _on_snake_direction_changed(new_direction:Vector2) -> void:
	target_position = new_direction * snake.width

func _on_snake_gain_weight(value:float) -> void:
	target_position = target_position.normalized() * value

func _on_snake_update_head(pos:Vector2) -> void:
	global_position = pos
