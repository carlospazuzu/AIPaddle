extends KinematicBody2D


const COLORS = ['green', 'blue', 'grey', 'purple', 'red', 'yellow']

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# randomly select a block color
	$Sprite.texture = load('res://assets/element_' + _get_random_color() + '_rectangle.png')
	



func _get_random_color() -> String:
	return COLORS[randi() % len(COLORS)]


func get_width():
	return $Sprite.texture.get_width()
	
	
func get_height():
	return $Sprite.texture.get_height()
