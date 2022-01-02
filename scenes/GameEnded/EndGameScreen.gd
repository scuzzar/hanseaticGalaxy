extends CenterContainer

onready var money = $GridContainer/MoneyValue

#var Sol_scene = preload("res://scenes/sol/Sol.tscn")
#


func _ready():	
	money.text = str(Player.credits)
	var save_game = File.new()
	if(!save_game.file_exists(Globals.QUICKSAVE_PATH)):
		$GridContainer/Load.hide()

func _on_Button_pressed():
	SceneManager.load_mainMenu()

func _on_Load_pressed():
	SceneManager.load_quicksave()
