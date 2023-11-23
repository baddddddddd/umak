extends RayCast2D

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var firing = $"..".firing
	if is_colliding() and firing:
		print("collide")
		var obj = get_collider()
		if obj.is_in_group("enemy"):
			obj.deplete_hp(500)
		
	
		
