extends ColorRect
@onready var a = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if a > 0:
		a -= delta / 2
		set_self_modulate(Color(1, 1, 1, a))
	else:
		queue_free()
		
