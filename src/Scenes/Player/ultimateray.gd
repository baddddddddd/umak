extends RayCast2D
@onready var fired = false
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var firing = $"..".firing
	if is_colliding() and firing:
		print("collide")
		var obj = get_collider()
		if obj.is_in_group("enemy") and fired == false:
			obj.deplete_hp(500)
			fired = true
		
	
		
