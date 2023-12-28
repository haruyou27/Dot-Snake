extends Line2D
class_name Snake

@onready var collision_shape := CircleShape2D.new()

var score := 10
var grow := .0
func eat(nutrient:int) -> void:
	score += nutrient
	grow += nutrient
	
	#Need a formula for snake width.
	#width += nutrient ???

var direction_head : Vector2
var direction_tail : Vector2
func _ready() -> void:
	if not is_multiplayer_authority():
		set_physics_process(false)
		set_process_unhandled_key_input(false)
		return
	
	clear_points()
	add_point(Vector2.ZERO)
	collision_shape.radius = width
	# Random start direction because why not.
	var rand := randf()
	if rand < .25:
		direction_head = Vector2.LEFT
	elif rand < .5:
		direction_head = Vector2.RIGHT
	elif  rand < .75:
		direction_head = Vector2.DOWN
	else:
		direction_head = Vector2.UP
	add_point(direction_head*10)
	direction_tail = (points[1] - points[0]).normalized()

func _unhandled_key_input(_event) -> void:
	var new_direction := Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	
	#You can't make a 360 degree turn.
	if not (new_direction + direction_head).is_zero_approx():
		direction_head = new_direction
		# 1 point for every corner.
		add_point(points[-1])

const speed_normal := 200.0
const speed_dash := 500.0
func _physics_process(delta:float) -> void:
	var speed := speed_normal
	if Input.is_action_pressed("dash"):
		speed = speed_dash
		score -= 1
		
	speed *= delta
	points[-1] += direction_head * speed
	
	#Grow the snake smoothly.
	if grow > 0:
		grow -= speed
	else:
		points[0] += speed * direction_tail
		#Remove tail point when overlap corner.
		if (points[1] - points[0]).is_zero_approx():
			remove_point(0)
			direction_tail = (points[1] - points[0]).normalized()
			
	rpc("update_position", points[-1], points[0])

signal update_head(pos:Vector2)
signal update_tail(pos:Vector2)
@rpc("unreliable","call_local")
func update_position(head:Vector2, tail:Vector2) -> void:
	points[0] = tail
	points[-1] = head
	update_head.emit(head)
	update_tail.emit(tail)

func die() -> void:
	#Spawn food item smth.
	pass
