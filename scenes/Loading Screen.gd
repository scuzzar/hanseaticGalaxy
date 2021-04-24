extends CenterContainer

var sol_scene_res : PackedScene
var loader : ResourceInteractiveLoader


func _ready():
	loader = ResourceLoader.load_interactive("res://scenes/Sol.tscn")
	if loader == null: # Check for errors.
		print("ERROR")
		return	
	set_process(true)

func _process(delta):	
	var err =loader.poll()
	$Loading_Lable.text = $Loading_Lable.text + "."
	if(err == ERR_FILE_EOF):	
		sol_scene_res = loader.get_resource() 
		print("loaded")
		$Loading_Lable.hide()
		$Start.show()
		set_process(false)

func _on_Start_pressed():
	print("Start")
	call_deferred("_loadSol")

func _loadSol():
	var result = get_tree().change_scene_to(sol_scene_res)	
	if(result==OK):	
		print("Game started")
	else:
		print("faild to load Scene!")
