extends Node2D

const ROWS = 4
const COLS = 14

onready var block = preload('res://entities/block/Block.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(COLS):
		for j in range(ROWS):
			var b = block.instance()
			var w = b.get_width()
			var h = b.get_height()
			b.position = Vector2(100 + w * i, 100 + h * j)
			$"/root/Main/BlockGroup".add_child(b)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
