extends Node2D


var level1 = preload("res://levels/Level1.tscn")
var death_screen = preload("res://world/DeathScreen.tscn")
var win_screen = preload("res://world/WinScreen.tscn")
var active_scene


func _ready():
	load_level()


func _on_Player_died():
	$DeathTimer.start()


func _on_Player_won():
	active_scene.queue_free()
	active_scene = win_screen.instance()
	add_child(active_scene)
	active_scene.rect_size = get_viewport_rect().size


func _on_DeathTimer_timeout():
	$RespawnTimer.start()
	remove_child(active_scene)
	active_scene = death_screen.instance()
	add_child(active_scene)
	active_scene.rect_size = get_viewport_rect().size


func _on_RespawnTimer_timeout():
	remove_child(active_scene)
	load_level()


func load_level():
	active_scene = level1.instance()
	add_child(active_scene)
	active_scene.connect("player_won", self, "_on_Player_won")
	active_scene.connect("player_died", self, "_on_Player_died")
