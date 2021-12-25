extends Area2D

var speed = 200
var buff
var buffs_name

var destroyed = false
func _ready():
	randomize()
	buff=rand_range(0.1,10)
	if buff<5.0:
		$AnimatedSprite.play("bolt")
		buffs_name="bolt"
	elif buff<8.0:
		$AnimatedSprite.play("star")
		buffs_name="star"
	else:
		$AnimatedSprite.play("pill")
		buffs_name="pill"
func _physics_process(delta):
	if not destroyed:
		position.y+=speed*delta

func get_name():
	return buffs_name

func destroy():
	$CollisionShape2D.set_deferred("disabled",true)
	if buffs_name == "bolt":
		$Label.text = "Energy refilled"
	elif buffs_name == "star":
		$Label.text = "3000 pts"
	else:
		$Label.text = "1 Life"
	$Label.visible = true
	$Tween.interpolate_property($Label,"modulate",$Label.modulate,Color(1,1,1,0),1,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()
func _on_PowerUp_area_entered(area):
	if area.is_in_group("Player") and not destroyed:
		$AudioStreamPlayer2D.play()
		$AnimatedSprite.play("null")
		yield($AudioStreamPlayer2D,"finished")
		destroyed = true
		destroy()



func _on_Tween_tween_all_completed():
	queue_free()
