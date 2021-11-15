extends Area2D

var speed = 200
var buff
var buffs_name
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
	position.y+=speed*delta
	
func get_name():
	return buffs_name

func _on_PowerUp_area_entered(area):
	if area.is_in_group("Player"):
		$AudioStreamPlayer2D.play()
		$AnimatedSprite.play("null")
		yield($AudioStreamPlayer2D,"finished")
		queue_free()
