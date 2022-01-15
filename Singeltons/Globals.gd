tool
extends Node

var G = 50
var loadPath = null
var QUICKSAVE_PATH = "user://quick.save"
var originShift = Vector3(0,0,0)
var velocity_shift =Vector3(0,0,0)
var show_names = false
var GameYear = 2327 #Seconds

func get_fuel_mass():
	return Typ.Cargo[TYP.CARGO.FUEL]["mass"]
