extends Node2D

onready var hbar=$CanvasLayer/Control/HealthBar
var asteroid=preload("res://Nodes/Asteroid.tscn")
var powerup=preload("res://Nodes/PowerUp.tscn")
const path="user://hipoints.dat"
var points=0
var hipoints=0
export (int) var bullet_count=30
export (float) var ast_waittime=1
export (float) var buff_waittime=5
var count=0
var level=1

func set_health(value):
	if hbar.rect_size.x!=0:
		hbar.rect_size.x=hbar.texture.get_size().x*value
	if value<=0:
		hbar.visible=false
	if value == 8:
		hbar.modulate = Color(1, 1, 0.5)
	elif value > 1:
		hbar.modulate = Color(1, 1, 1)
	else:
		hbar.modulate = Color(1, 0.5, 0.5)
func _ready():
	randomize()
	if hipoints!=0:
		load_hipoints()
	set_health(3)
	$CanvasLayer/Control/Label.text="Speed " + String(level)
	set_bullet(bullet_count)
	Engine.time_scale=1
	points=0
	$CanvasLayer/Control2/MenuRect.visible=false
	$CanvasLayer/Control2/LoseRect.visible=false
	$Timer.wait_time=ast_waittime
	$Timer.start()
	if OS.get_name() == "Windows":
		$CanvasLayer/Control2/StartRec/StartButton.grab_focus()
	get_tree().paused=true
func _physics_process(delta):
	if $AudioStreamPlayer.playing==false:
		$AudioStreamPlayer.play()
	$CanvasLayer/Control/Point.text=String(points)
	if Input.is_action_just_pressed("ui_focus_next"):
		Engine.time_scale+=0.1
	if Input.is_action_just_pressed("pause_game"):
		_on_Buttonpause_pressed()
		if OS.get_name() == "Windows":
			$CanvasLayer/Control2/MenuRect/VBoxContainer/ResumeButton.grab_focus()
	level_changer()
func _on_Player_health_changed(value):
	set_health(value)
func _on_Timer_timeout():
	$CanvasLayer/Control/Label.text="Level " + String(int((Engine.time_scale-1)*10)+1)
	count+=1
	var pos = Vector2 (rand_range(50,400),0)
	var inst=asteroid.instance()
	inst.position=pos
	get_node("Asteroids").add_child(inst)
	if ($CanvasLayer/Control2/LoseRect.visible==false):
		points+=50
func add_point(value):
	points+=value
func level_changer():
	if (count==20):
		count=0
		Engine.time_scale+=0.1
		level+=1

func set_bullet(value):
	bullet_count=value
	get_node("CanvasLayer/Control/PowerBar").set_current(value)
func _on_BuffTimer_timeout():
	var inst = powerup.instance()
	inst.position.x=rand_range(30,420)
	$BuffTimer.wait_time=rand_range(5,7)/Engine.time_scale
	get_node("PowerUps").add_child(inst)

func _on_Button_pressed():
	if $CanvasLayer/Control2.mouse_filter==Control.MOUSE_FILTER_STOP:
		$CanvasLayer/Control2.mouse_filter=Control.MOUSE_FILTER_IGNORE
	$CanvasLayer/Control2/StartRec.visible=false
	$CanvasLayer/Control2/StartRec/startaudio.play()
	yield(get_tree().create_timer(1),"timeout")
	get_tree().paused=!get_tree().paused
	$CanvasLayer/Control/Button.visible=true
	if get_tree().paused:
		$CanvasLayer/Control2/MenuRect.visible=true

func _on_Player_player_died():
	yield(get_tree().create_timer(1),"timeout")
#	load_hipoints()
#	if (points>hipoints):
#		hipoints=points
#		save_hipoints()
	$CanvasLayer/Control2/LoseRect/PointsLabel.text="Points: " + String(points)
	$CanvasLayer/Control2/LoseRect/HiPointLabel.text="Hi-Scỏores: " +String(hipoints)
	if OS.get_name() == "Windows":
		$CanvasLayer/Control2/LoseRect/VBoxContainer/RetryButton.grab_focus()
	$CanvasLayer/Control2/LoseRect.visible=true


func _on_RetryButton_pressed():
	get_tree().reload_current_scene()

func _on_HomeButton_pressed():
	get_tree().paused=false
	get_tree().change_scene("res://Nodes/MainMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func load_hipoints():
	var file=File.new()
	file.open(path,File.READ)
	hipoints=file.get_var()
	file.close()
	pass

func save_hipoints():
	var file=File.new()
	file.open(path,File.WRITE)
	file.store_var(hipoints)
	file.close()
	pass

func _on_Buttonpause_pressed():
	$CanvasLayer/Control2/StartRec/startaudio.play()
	get_tree().paused=!get_tree().paused
	if get_tree().paused:
		$CanvasLayer/Control2/MenuRect.visible=true

func _on_MenuRect_button_pressed(button):
	if button=="home":
		_on_HomeButton_pressed()
	elif button=="quit":
		_on_QuitButton_pressed()
