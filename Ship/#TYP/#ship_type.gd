@tool
extends Resource

class_name ShipType

@export var id : int = 0
@export var Display_name := ""

@export var hull : PackedScene

@export var dry_mass 					: float 	 = 0.0
@export var turn_rate 					: float 	 = 0.0
@export var fuel_cap 					: float 	 = 0.0
@export var max_hp 						: float 	 = 0.0
@export var price 						: float 	 = 0.0

@export var default_engine : EngineType = preload("res://Ship/#TYP/engine/ip_drive.tres")
@export var default_truster : EngineType = preload("res://Ship/#TYP/engine/base_truster.tres")

