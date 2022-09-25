extends Control


var loader : ResourceLoader


func _ready():
	Globals.RAN = RandomNumberGenerator.new()
	Globals.RAN.seed = 42
	$Menu.hide()
	$Menu/Resume.hide()
	SceneManager.sol_scene_res = ResourceLoader.load("res://scenes/sol/Sol.tscn")
	print("loaded")
	$Loading_Lable.hide()
	$Menu.show()
	var quicksave = File.new()
	if(quicksave.file_exists(Globals.QUICKSAVE_PATH)):
		$Menu/Resume.show()



func _on_Start_pressed():
	print("Start")
	call_deferred("_loadSol")

func _loadSol():
	var result = get_tree().change_scene_to_packed(SceneManager.sol_scene_res)
	if(result==OK):	
		print("Game started")
	else:
		print("faild to load Scene!")


func _on_Resume_pressed():
	SceneManager.load_quicksave()


func _on_Exit_pressed():
	SceneManager.exit_game()


func _on_FullScreen_pressed():
	if(DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
