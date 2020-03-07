extends KinematicBody2D


const SPEED = 200
var direction = Vector2(-1, -1) # initially, moves left and up

var screen_width
var screen_height

var movement

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement = direction * SPEED * delta
	
	var collision = move_and_collide(movement)
	
	# destroys the object the ball touched 
	if collision:
		if collision.collider.get('name') != 'Paddle':
			collision.collider.free()
		if collision.normal.x != 0:
			direction.x = collision.normal.x
		else:
			direction.x = [1, -1][randi() % 2]
		if collision.normal.y != 0:
			direction.y = collision.normal.y
		
	_keep_inside_screen_bounds()


# function to avoid the ball to go outside screen bounds
func _keep_inside_screen_bounds() -> void:
	if position.x <= $Sprite.texture.get_width() / 2:
		direction.x = 1
	if position.x >= screen_width - $Sprite.texture.get_width() / 2:
		direction.x = -1
	if position.y <= $Sprite.texture.get_height() / 2:
		direction.y = 1
	if position.y >= screen_height - $Sprite.texture.get_height() / 2:
		direction.y = -1


func _restart():
	var values = [1, -1]
	direction = Vector2(values[randi() % 2], -1) 
	position = Vector2(505, 514)
