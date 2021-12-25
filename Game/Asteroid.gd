extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed=300
var health=2

func set_speed(value):
	speed*=value
func move(delta):
	position.y+=speed*delta
	pass
# Calld when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$CSbig.disabled=true
	$CSsmall.disabled=true

	var count=rand_range(1,4)
	if int(count)==4:
		$CSsmall.disabled=false
	else:
		$CSbig.disabled=false
	$AnimatedSprite.play(String(int(count)))

func _physics_process(delta):
	move(delta)
	rotation_degrees+=rand_range(0,1)
func damage(value):
	health-=value
	if health==0:
		destroy(1.5,5,"player")
func _on_Asteroid_area_entered(area):
	if area.is_in_group("damagable"):
		damage(1)
	if area.is_in_group("Player"):
		area.damage(1)
		destroy(1.5,5,"player")
	if area.is_in_group("BlackHole"):
		destroy(0.5,2,"blackhole")
func destroy(time,power,actor):
	if actor=="player":
		get_parent().get_parent().get_node("Shake").screen_shake(time,power,200)
		get_parent().get_parent().add_point(500)
		$AudioStreamPlayer2D.play()
	$CSbig.set_deferred("disabled",true)
	$CSsmall.set_deferred("disabled",true)
	$AnimatedSprite.scale=Vector2(1.5,1.5)
	$AnimatedSprite.play("explosion")
	yield($AnimatedSprite,"animation_finished")
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	#destroy()
	pass
