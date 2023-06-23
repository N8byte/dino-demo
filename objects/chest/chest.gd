extends Node

@onready var animation = $AnimationPlayer
@onready var remoteTransform = $RemoteTransform2D
@onready var collider = $Area2D/CollisionShape2D

const itemFolder = "res://items"
var items : Array
var itemNames : Array


#preload the itemFolders
func _ready():
	items = []
	itemNames = []
	var itemsDir = DirAccess.open(itemFolder)

	#error checking
	if !itemsDir:
		print("ERROR: could not load items folder")
		return

	#fill itemFolders[] with all the items
	itemsDir.list_dir_begin()
	var currentFolder = itemsDir.get_next()
	while currentFolder != "":
		if itemsDir.current_is_dir():
			items.append(load(itemFolder + "/" + currentFolder + "/" + currentFolder + ".tscn"))
			itemNames.append(currentFolder)
		currentFolder = itemsDir.get_next()


func openChest():
	var item : String = generateItem()
	var droppedItem = load(itemFolder + "/" + item + "/sprite.tscn")
	var instancedItem = droppedItem.instantiate()
	get_tree().root.add_child(instancedItem)
	remoteTransform.set_remote_node(instancedItem.get_path())
	collider.set_disabled(true)
	animation.play("open")


func generateItem() -> String:
	var item = itemNames.pick_random()
	return item
