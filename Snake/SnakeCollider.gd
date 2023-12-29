extends Area2D
class_name SnakeCollider

@onready var snake :Snake = $".."
var shapes : Array[CapsuleShape2D] = []
var shape_tail := CapsuleShape2D.new()
var shape_head : CapsuleShape2D
func _ready() -> void:
	if not is_multiplayer_authority():
		queue_free()
		return
	shape_tail.radius = snake.width
	shape_tail.height = shape_tail.radius
	shapes.append(shape_tail)

var angle_tail := .0
var angle_head := .0
func _on_snake_update_head(head:Vector2) -> void:
	var delta :Vector2 = snake.delta_tail / 2
	PhysicsServer2D.area_set_shape_transform(get_rid(), 0, Transform2D(angle_tail, delta + snake.points[0]))
	shape_tail.height = delta.length()
	
	if shapes.size() > 1:
		delta = (snake.points[-2] - snake.points[-1]) / 2
		PhysicsServer2D.area_set_shape_transform(get_rid(), 0, Transform2D(angle_head, delta + snake.points[-1]))
		shape_head.height = delta.length()

func _on_snake_direction_changed(new_direction:Vector2) -> void:
	shape_head = CapsuleShape2D.new()
	shape_head.radius = snake.width
	shape_head.height = shape_head.radius
	angle_head = new_direction.angle()
	PhysicsServer2D.area_add_shape(get_rid(), shape_head.get_rid(), Transform2D(angle_head, snake.points[-1]))
	shapes.append(shape_head)

func _on_snake_remove_corner() -> void:
	PhysicsServer2D.area_remove_shape(get_rid(), 0)
	shapes.remove_at(0)
	shape_tail = shapes[0]
	angle_tail = snake.direction_tail.angle()

func _on_snake_gain_weight(value:float) -> void:
	for shape in shapes:
		shape.radius = value
