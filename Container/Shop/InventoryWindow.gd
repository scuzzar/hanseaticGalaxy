extends Panel

var rawScene = preload("res://Container/Shop/raw.tscn")
onready var vBox = $"Container/VBoxContainer"

var inventor
signal accepted(container)

func _ready():
	inventor = self.get_parent()
	hide()
	#add_raw("test","test","test","test")
	#add_raw("test","test","test","test")
	#add_raw("test","test","test","test")
	pass # Replace with function body.

func update():
	if(self.visible):
		for n in vBox.get_children():
			vBox.remove_child(n)
			n.queue_free()
		var container = inventor.getAllContainter()
		for c in container:
			add_container(c)

func add_container(container:MissionContainer):
	var newRaw = rawScene.instance()	
	newRaw.setContent(container)
	newRaw.connect("accepted",self,"_on_accepted")
	vBox.add_child(newRaw) # Add it as a child of this node.

func _on_accepted(container:MissionContainer):
	emit_signal("accepted",container)
	update()

func _on_visibility_changed():
	if(self.is_visible_in_tree()):
		update()
