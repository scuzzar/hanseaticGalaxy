extends Node

var mainMenue_scene = load("res://scenes/LoadingScreen/Loading Screen.tscn")
var sol_scene_res =load("res://scenes/sol/Sol.tscn")
var endScreen = load("res://scenes/GameEnded/EndGameScreen.tscn")

func load_save(path):
	Globals.loadPath = path
	get_tree().change_scene_to_packed(SceneManager.sol_scene_res)

func load_quicksave():
	load_save(Globals.QUICKSAVE_PATH)

func load_mainMenu():
	get_tree().change_scene_to(mainMenue_scene)

func exit_game():
	get_tree().quit()
