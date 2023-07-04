extends Area2D

@onready var collider = $CollisionShape2D
@onready var animation = $AnimationPlayer
var useable #the scene of the item (sword, health, etc.)
var itemReceiver #the body that is trying to obtain this item


func droppedFromChest(scene):
	animation.play("droppedFromChest")
	useable = scene


func pickedUp():
	set_monitoring(false)
	animation.play("pickedUp")
	collider.set_disabled(true)


func _physics_process(_delta):
	if is_monitoring():
		for body in get_overlapping_bodies():
			if body.is_in_group("receivesItems"):
				pickedUp()
				itemReceiver = body


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pickedUp":
		itemReceiver.add_child(useable)
		queue_free()
