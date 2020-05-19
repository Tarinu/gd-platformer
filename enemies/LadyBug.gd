extends KinematicBody2D

signal died
signal player_hit

export (NodePath) var patrol_path
var move_speed = 100
onready var patrol_points = get_node(patrol_path).curve.get_baked_points()
var patrol_index = 0
var velocity = Vector2()
const GRAVITY = 250


func _physics_process(_delta):
	var target = patrol_points[patrol_index]
	if Vector2(position.x, 0).distance_to(Vector2(target.x, 0)) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	velocity = (Vector2(target.x, 0) - Vector2(position.x, 0)).normalized() * move_speed
	velocity = move_and_slide(Vector2(velocity.x, 400), Vector2.UP)
	if velocity.x > 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false


func _on_KillZone_body_entered(_body):
	emit_signal("player_hit")


func _on_HitBox_body_entered(_body):
	set_physics_process(false)
	$KillZone.queue_free()
	$HitBox.queue_free()
	$AnimatedSprite.stop()
	$DeathAnimation.play("DeathAnimation")


func _on_DeathAnimation_animation_finished(_anim_name):
	emit_signal("died", self)
