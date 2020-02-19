extends Box
class_name PhysicBox

func push(velocity: Vector2)->void:
	move_and_slide(velocity)

