extends CenterContainer

@onready var money = $GridContainer/MoneyValue

#var Sol_scene = preload("res://scenes/sol/Sol.tscn")
#


func _ready():	
	money.text = str(Player.credits)
	if(!FileAccess.file_exists(Globals.QUICKSAVE_PATH)):
		$GridContainer/Load.hide()

func _on_Button_pressed():
	Globals.loadPath = null
	SceneManager.load_mainMenu()

func _on_Load_pressed():
	SceneManager.load_quicksave()
