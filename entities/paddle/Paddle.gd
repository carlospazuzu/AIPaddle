extends KinematicBody2D

const SPEED = 400

var nn = load('res://scripts/NeuralNetwork.gd')

var neural_network
var screen_width
var screen_height

# Called when the node enters the scene tree for the first time.
func _ready():
	neural_network = nn.new()
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var ball_position = $"/root/Main/Ball".position
	
	var nn_out = neural_network._train([ball_position.x / screen_width], 
						  _get_direction_sign(ball_position))
						
	var movement = Vector2()
	
	# if Input.is_action_pressed("ui_left"):
	if nn_out < 0.5:
		movement.x -= SPEED
	# if Input.is_action_pressed("ui_right"):
	if nn_out >= 0.5:
		movement.x += SPEED
	
	movement *= delta
	
	move_and_collide(movement)
	
	if position.x <= $Sprite.texture.get_width() / 2:
		position.x = $Sprite.texture.get_width() / 2
	if position.x >= get_viewport_rect().size.x - $Sprite.texture.get_width() / 2:
		position.x = get_viewport_rect().size.x - $Sprite.texture.get_width() / 2
	
# gets correct neural network output based on current ball position
func _get_direction_sign(ball_position) -> int:
	if ball_position.x < position.x: # + $Sprite.texture.get_width() / 2:
		return 0
	else:
		return 1
