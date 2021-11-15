extends Node2D

var current_shake_priority=0
func move_camera(vector):
	get_parent().get_node("Camera2D").offset=Vector2(rand_range(-vector.x,vector.x),rand_range(-vector.y,vector.y))
func screen_shake(shake_time,shake_power,shake_prior):
	if shake_prior>=current_shake_priority:
		$Tween.interpolate_method(self,"move_camera",Vector2(shake_power,shake_power),Vector2(0,0),Tween.TRANS_SINE,Tween.EASE_OUT,0)
		$Tween.start()



func _on_Tween_tween_all_completed():
	current_shake_priority=0
