extends Area2D

var speed=700
func _ready():
	$AudioStreamPlayer.play()
func _physics_process(delta):
	position.y-=speed*delta


func _on_Bullet_area_entered(area):
	if area.is_in_group("Blockable"):
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
