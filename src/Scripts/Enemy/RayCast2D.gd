extends RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var firing = $"..".get("firing")
	if is_colliding() and firing:
		var obj = get_collider()
		
		if obj.is_in_group("friendly"):
			obj.deplete_hp(20)
		
	
		
