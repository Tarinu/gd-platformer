extends TileMap


signal player_won
signal player_died


onready var screen_size = get_viewport_rect().size


func _process(_delta):
	if $Player.position.y >= screen_size.y:
		emit_signal("player_died")
		set_process(false)


func _on_Finish_body_entered(_body):
	emit_signal("player_won")


func _on_player_hit():
	emit_signal("player_died")
	$Player.disable()


func _on_LadyBug_died(mob):
	mob.queue_free()
