extends Control

func _ready():
	if OS.get_name() == "Windows":
		$Control/VBoxContainer/PlayButton.grab_focus()
	pass

func _process(delta):
	if $AudioStreamPlayer.playing==false:
		$AudioStreamPlayer.play()


func _on_ExitButton_pressed():
	$clickaudio.play()
	get_tree().quit()



func _on_PlayButton_pressed():
	$clickaudio.play()
	yield(get_tree().create_timer(1.0),"timeout")
	get_tree().change_scene("res://Node2D.tscn")



func _on_PlayButton_focus_entered():
	$clickaudio.play()


func _on_ExitButton_focus_entered():
	$clickaudio.play()
