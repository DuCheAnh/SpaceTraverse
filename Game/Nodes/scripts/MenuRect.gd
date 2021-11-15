extends ColorRect

signal button_pressed

func _on_ResumeButton_pressed():
	if get_tree().paused:
		get_tree().paused=false
		visible=false


func _on_HomeButton_pressed():
	get_tree().change_scene("res://Nodes/MainMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
