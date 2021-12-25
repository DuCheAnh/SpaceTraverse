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
	yield($clickaudio,"finished")
	get_tree().change_scene("res://Node2D.tscn")

