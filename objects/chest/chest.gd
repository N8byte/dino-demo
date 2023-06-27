extends Node

@onready var animation := $AnimationPlayer
@onready var remoteTransform := $RemoteTransform2D
@onready var collider := $Area2D/CollisionShape2D

const ITEM_FOLDER = "res://items"
var items : Array #list of 'items' (inner class)
#var sprites : Array #list of scenes
var pickupScene : Area2D


class item:
	var name : String
	var scene : PackedScene
	var sprite : PackedScene

	func _init(_name : String, _sprite: PackedScene, _scene : PackedScene):
		name = _name
		scene = _scene
		sprite = _sprite

	func instantiate():
		return scene.instantiate()

	func getSprite():
		return sprite.instantiate()


func preloadItems():
	items = []
	var itemsDir = DirAccess.open(ITEM_FOLDER)

	#error checking
	if !itemsDir:
		print("ERROR: could not load items folder")
		return

	#fill items[] array
	itemsDir.list_dir_begin()
	var currentFolder : String = itemsDir.get_next()
	while currentFolder != "":
		if itemsDir.current_is_dir():
			var name = currentFolder
			var scene = load(ITEM_FOLDER + "/" + currentFolder + "/sprite.tscn")
			var sprite = load(ITEM_FOLDER + "/" + currentFolder + "/" + currentFolder + ".tscn")
			items.append(item.new(name, scene, sprite))
		currentFolder = itemsDir.get_next()


func _ready():
	preloadItems()
	pickupScene = preload("res://items/pickup.tscn").instantiate()


func openChest(rarity := 1):
	# generate item
	var item : item = generateItem()

	# place item pickup in scene
	var pickup = pickupScene.duplicate()
	pickup.add_child(item.getSprite())
	get_tree().get_root().add_child(pickup)
	remoteTransform.set_remote_node(pickup.get_path())
#	var instancedItem = item.instantiate()
#	get_tree().get_root().add_child(instancedItem)
#	remoteTransform.set_remote_node(instancedItem.get_path())

	collider.set_disabled(true)
	animation.play("open")


func generateItem() -> item:
	var item = items.pick_random()
	return item
