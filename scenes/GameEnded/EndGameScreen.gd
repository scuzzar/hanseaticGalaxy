extends CenterContainer

onready var money = $VSplitContainer/GridContainer/MoneyValue


func _ready():	
	money.text = str(Player.credits)
