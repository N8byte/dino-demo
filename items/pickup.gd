extends Area2D

@onready var collider = $CollisionShape2D
@onready var timer = $Timer
@onready var animation = $AnimationPlayer


func pickedUp():
	timer.start(3)
	animation.play("pickedUp")
	collider.set_disabled(true)


func _physics_process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("receivesItems"):
			body.receiveItem("sword")
			pickedUp()


func _on_timer_timeout():
	queue_free()
