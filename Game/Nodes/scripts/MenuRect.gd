extends ColorRect

signal button_pressed
onready var audio = get_parent().get_parent().get_parent().get_node("ClickAudio")

func _on_ResumeButton_pressed():
	audio.play()
	yield(audio,"finished")
	if get_tree().paused:
		get_tree().paused=false
		visible=false


func _on_HomeButton_pressed():
	audio.play()
	yield(audio,"finished")
	get_tree().change_scene("res://Nodes/MainMenu.tscn")


func _on_QuitButton_pressed():
	audio.play()
	yield(audio,"finished")
	get_tree().quit()


func _on_ResumeButton_focus_entered():
	audio.play()


func _on_HomeButton_focus_entered():
	audio.play()



func _on_QuitButton_focus_entered():
	audio.play()

