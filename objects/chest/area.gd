extends Area2D

@onready var parent = get_parent()

func interact():
	parent.openChest();
