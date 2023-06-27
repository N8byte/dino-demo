extends CharacterBody2D

@export var speed : float = 70.0

@onready var animationState = $AnimationTree.get("parameters/playback")
@onready var animationPlayer = $AnimationPlayer
@onready var kickArea = $kickArea

enum {LEFT, RIGHT}
var previousDirection : int = RIGHT


func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * speed
		animationState.travel("walkRight")
	else:
		velocity = Vector2.ZERO
		animationState.travel("idleRight")

	#face other direction
	if (direction.x < 0 && previousDirection != LEFT):
		apply_scale(Vector2(-1, 1))
		previousDirection = LEFT
	elif (direction.x > 0 && previousDirection != RIGHT):
		apply_scale(Vector2(-1, 1))
		previousDirection = RIGHT

	#kicking
	if Input.is_action_just_pressed("attack"):
		animationState.travel("kickRight")

	#open chest
	if animationState.get_current_node() == &"kickRight":
		for area in kickArea.get_overlapping_areas():
			if area.is_in_group("interactable"):
				area.interact()

	move_and_slide()


func receiveItem(item):
	print(item)
