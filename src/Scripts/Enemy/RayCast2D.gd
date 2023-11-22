extends RayCast2D
# Called when the node enters the scene tree for the first time.


@onready var a = $"../../player"
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var firing = $"../..".get("firing")
	if is_colliding() and firing:
		pass
		
	
		
