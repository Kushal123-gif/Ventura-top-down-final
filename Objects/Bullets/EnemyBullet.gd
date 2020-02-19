extends "res://Objects/Bullets/Bullet.gd"
class_name EnemyBullet


func _on_EnemyBullet_body_entered(body: PhysicsBody2D) -> void:
	explode()
