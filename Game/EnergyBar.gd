extends ProgressBar


export (int) var max_bullet = 30
var current_bullet=max_bullet

func _ready():
	set_max(max_bullet)
func set_current(val):
	current_bullet=clamp(val,0,max_bullet)
	value=current_bullet

func set_max(val):
	max_bullet=val
	max_value=val

