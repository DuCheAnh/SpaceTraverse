extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dir=Vector2(1,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


func _process(delta):
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		dir*=-1
		$RayCast2D.cast_to=dir*90

func _on_Timer_timeout():
	$Tween.interpolate_property(self,"position",position,position+dir*90,0.5,Tween.TRANS_QUINT,Tween.EASE_OUT)
	$Tween.start()
	$Timer.start()


