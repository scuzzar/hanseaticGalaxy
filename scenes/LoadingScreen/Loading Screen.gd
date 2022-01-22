extends Control


var loader : ResourceInteractiveLoader


func _ready():
	Globals.RAN = RandomNumberGenerator.new()
	Globals.RAN.seed = 42
	$Menu.hide()
	$Menu/Resume.hide()
	loader = ResourceLoader.load_interactive("res://scenes/sol/Sol.tscn")
	if loader == null: # Check for errors.
		print("ERROR")
		return	
	set_process(true)

func _process(delta):	
	var err =loader.poll()
	$Loading_Lable.text = $Loading_Lable.text + "."
	if(err == ERR_FILE_EOF):	
		SceneManager.sol_scene_res = loader.get_resource() 
		print("loaded")
		$Loading_Lable.hide()
		$Menu.show()
		var quicksave = File.new()
		if(quicksave.file_exists(Globals.QUICKSAVE_PATH)):
			$Menu/Resume.show()
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


func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
