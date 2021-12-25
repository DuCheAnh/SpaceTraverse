extends Area2D

signal swipe
var swipe_start = null
var minimum_drag = 20
var current_health=3
export (int) var max_health=8
var charging=false
var bullet_charge=30
var max_bulletcharge=30
var heart=3
var bullet=preload("res://Nodes/Bullet.tscn")
signal health_changed
signal player_died
func _ready():
	$Bullet_timer.stop()

func _physics_process(delta):
	if current_health>0:
		if charging:
			position.y-=gravity*delta/Engine.time_scale
			position.y=clamp(position.y,0,get_viewport_rect().size.y+50)
			$FireSprite.play("fire")
			if $AudioStreamPlayer.playing==false:
				$AudioStreamPlayer.play()
		else:
			position.y+=gravity*delta/Engine.time_scale
			$FireSprite.play("none")
			$AudioStreamPlayer.playing=false
		#debug
		if Input.is_action_just_pressed("ui_accept"):
			health_changed(current_health)
		if Input.is_action_just_pressed("ui_left"):
			emit_signal("swipe","left")
		elif Input.is_action_just_pressed("ui_right"):
			emit_signal("swipe","right")
		if Input.is_action_just_pressed("add_health"):
			health_changed(current_health+1)
#movements
func _calculate_swipe(swipe_end):
	if swipe_start == null:
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			emit_signal("swipe", "right")
		elif swipe.x<0:
			emit_signal("swipe", "left")
func _unhandled_input(event):
	if event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		shoot(charging)
		swipe_start = get_global_mouse_position()
		charging=true
	if event.is_action_released("click") or event.is_action_released("ui_accept"):
		_calculate_swipe(get_global_mouse_position())
		charging=false
func _on_Player_swipe(direction):
	var vpx=get_viewport_rect().size.x-90;
	if direction=="right":
		$Tween.interpolate_property(self,"position",position,Vector2(clamp(position.x+90,0,vpx),position.y),0.1,Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()
	elif direction=="left":
		$Tween.interpolate_property(self,"position",position,Vector2(clamp(position.x-90,0,vpx),position.y),0.1,Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()

#Health
func health_changed(value):
	current_health=clamp(value,0,max_health)
	emit_signal("health_changed",current_health)
	pass
func destroy(time,power):
	get_parent().get_node("Shake").screen_shake(time,power,200)
	$AnimatedSprite.position=Vector2(-25,-35)
	$AnimatedSprite.play("explode")
	$CollisionShape2D.set_deferred("disabled",true)
	$deadaudio.play()
	yield($AnimatedSprite,"animation_finished")
	emit_signal("player_died")
	queue_free()
func damage(value):
	current_health-=value
	health_changed(current_health)
	if current_health<=0:
		current_health=0
		destroy(2,7)
		#get_tree().change_scene("res://Node2D.tscn")

#Shooting
func shoot(config):
	if $Bullet_timer.is_stopped() and bullet_charge>0:
		var inst=bullet.instance()
		inst.position=$Guns/Mid_pos.global_position
		get_parent().add_child(inst)
		$Bullet_timer.start()
		get_parent().get_node("Shake").screen_shake(1,0.5,100)
		bullet_charge-=1
		get_parent().set_bullet(bullet_charge)

func _on_Bullet_timer_timeout():
	$Bullet_timer.stop()


func _on_Player_area_entered(area):
	if area.is_in_group("PowerUp"):
		if area.get_name()=="bolt":
			bullet_charge=clamp(bullet_charge+30,0,max_bulletcharge)
			get_parent().set_bullet(bullet_charge)
			#get_parent().
		elif area.get_name()=="pill":
			current_health=clamp(current_health+1,0,max_health)
			health_changed(current_health)
		elif area.get_name()=="star":
			get_parent().add_point(3000)
