extends CenterContainer


var loader : ResourceInteractiveLoader


func _ready():
	loader = ResourceLoader.load_interactive("res://scenes/sol/Sol.tscn")
	if loader == null: # Check for errors.
		print("ERROR")
		return	
	set_process(true)

func _process(delta):	
	var err =loader.poll()
	$Grid/Loading_Lable.text = $Grid/Loading_Lable.text + "."
	if(err == ERR_FILE_EOF):	
		SceneManager.sol_scene_res = loader.get_resource() 
		print("loaded")
		$Grid/Loading_Lable.hide()
		$Grid/Start.show()
		$Grid/Exit.show()
		var quicksave = File.new()
		if(quicksave.file_exists(Globals.QUICKSAVE_PATH)):
			$Grid/Resume.show()
		set_process(false)

func _on_Start_pressed():
	print("Start")
	call_deferred("_loadSol")

func _loadSol():
	var result = get_tree().change_scene_to(SceneManager.sol_scene_res)
	if(result==OK):	
		print("Game started")
	else:
		print("faild to load Scene!")


func _on_Resume_pressed():
	SceneManager.load_quicksave()


func _on_Exit_pressed():
	SceneManager.exit_game()
