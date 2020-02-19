extends KinematicBody2D
class_name Player

signal shoot

export (PackedScene) var Bullet
export (float) var shoot_cooldown
export var move_speed=1500
export var push_speed=120.0
export var hit_speed=120.0
export var friction=-300
export var MAX_SPEED=200
export var HEALTH=100

var motion=Vector2()
var before_direction=Vector2()
var direction=Vector2()
var Position2d_position=Vector2(35,35)
var ideal_state
var music
onready var tween=get_node("Tween")
onready var timer=get_node("Timer")

var can_shoot=true
var facing="front"

func _ready() -> void:
	music = AudioStreamPlayer2D.new()
	self.add_child(music)
	print(HEALTH)
	timer.wait_time=shoot_cooldown
	set_physics_process(true)
	$AnimatedSprite.play("ideal_front",true)

func _physics_process(delta: float) -> void:
	before_direction=direction
	direction=calculate_normalized_direction()
	if abs(direction.x)+abs(direction.y)<2:
		if Input.is_action_just_pressed("shoot"):
			shoot()
		if Input.is_action_just_pressed("boost"):
			MAX_SPEED=300.0
		if Input.is_action_just_released("boost"):
			MAX_SPEED=200.0
		update_animation(direction,before_direction)
		set_position2d()
		motion=calculate_motion(direction,move_speed,delta)
		motion=limit_velocity(motion)
		move_and_slide(motion)
		if get_slide_count()>0:
			check_box_collision(direction)
		if get_slide_count()==1:
			check_trap_collision(direction)
	else:
		print("cannot move")
	
func calculate_normalized_direction() -> Vector2:
	var new_motion= Vector2()
	new_motion.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	new_motion.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	return new_motion

func calculate_motion(direction: Vector2, move_speed: float,delta: float)-> Vector2:
	var vel=Vector2()
	direction.x=direction.x*move_speed
	direction.y=direction.y*move_speed
	if direction.x==0 and direction.y==0:
		direction.x=vel.x*friction
		direction.y=vel.y*friction
	vel.x=vel.x+direction.x
	vel.y=vel.y+direction.y
	return vel

func limit_velocity(velocity:Vector2):
	#USED TO LIMIT THE VELOCITY OF THE CHARACTER TO THE MAX SPEED
	velocity.x=clamp(velocity.x,-MAX_SPEED,MAX_SPEED)
	velocity.y=clamp(velocity.y,-MAX_SPEED,MAX_SPEED)
	return velocity

	
func check_box_collision(direction: Vector2):
	if abs(direction.x)+abs(direction.y)>1:
		return
	var box:= get_slide_collision(0).collider as Box
	if box:
		box.push(direction.normalized()*push_speed)

func check_trap_collision(direction: Vector2):
	var trap:= get_slide_collision(0).collider as Trap 
	if trap:
		var move_to=calculate_position_after_hit(direction)
		print(move_to)
		tween.interpolate_property(self,"position",get_position(),move_to,0.1,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
		tween.start()
		yield(tween,"tween_completed")
		#opacity_decrease()
		when_hit()
		
func update_animation(direction,before_direction):
	if direction.x==0 and direction.y==0 and $AnimatedSprite.is_playing():
		if before_direction.x>0:
			$AnimatedSprite.stop()
			$AnimatedSprite.play("ideal_right")
		if before_direction.x<0:
			$AnimatedSprite.stop()
			$AnimatedSprite.play("ideal_left")
		if before_direction.y>0:
			$AnimatedSprite.stop()
			$AnimatedSprite.play("ideal_front")
		if before_direction.y<0:
			$AnimatedSprite.stop()
			$AnimatedSprite.play("ideal_back")
	else:
		if direction.x<0:
			$AnimatedSprite.play("walking left")
		if direction.x>0:
			$AnimatedSprite.play("walking_right")
		if direction.y<0:
			$AnimatedSprite.play("walking_back")
		if direction.y>0:
			$AnimatedSprite.play("walking_front")
		
func when_hit():
	HEALTH-=10
	print("Remaining Health: "+ str(HEALTH))

func calculate_position_after_hit(direction: Vector2):
	if direction==Vector2(0,0):
		return Vector2(get_position().x-50,get_position().y-50)
	else:
		return Vector2(get_position().x+(direction.x*-50),get_position().y+(direction.y*-50))
		
	
func damage(damage):
	print (HEALTH)
	HEALTH-=damage
	if HEALTH<=0:
		queue_free()
	
func set_position2d():
	$"firing direction".look_at(get_global_mouse_position())

func shoot():
	if can_shoot:
		can_shoot = false
		timer.start()
		var dir = Vector2(1, 0).rotated($"firing direction".global_rotation)
		emit_signal('shoot', Bullet, $"firing direction/Firing".global_position, dir)

func _on_Timer_timeout() -> void:
	can_shoot=true


func _on_Bullet_area_area_entered(area: Area2D) -> void:
	if area is EnemyBullet:
		damage(area.damage)


func _on_Area2D_area_entered(area):
	if area.name == 'village':
		music.set_volume_db(10)
		music.stream = load('res://Audio and sound effects/village.ogg') 
		music.play()
	elif area.name == 'forest':
		music.set_volume_db(0)
		music.stream = load('res://Audio and sound effects/forest_noise.ogg')
		music.play()
	elif area.name == 'wizard_place':
		music.set_volume_db(0)
		music.stream = load('res://Audio and sound effects/wizard_mystery.ogg')
		music.play()
