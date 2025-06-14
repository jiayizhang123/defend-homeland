extends Node2D

@onready var path1a = preload("res://map/level1-patha.tscn")
@onready var path1b = preload("res://map/level1-pathb.tscn")
@onready var path2a = preload("res://map/level2-patha.tscn")
@onready var path2b = preload("res://map/level2-pathb.tscn")

func _ready(): #set the number of wave
	if Config.wave == 1 and Config.level == 1:
		Config.wave_n = Config.wavea[0]
	elif Config.wave == 2 and Config.level == 1:
		Config.wave_n = Config.wavea[1]

func _on_timer_timeout(): #generate enenmies in an interval, Timer1 is the count down timer at start 
	if Config.gameover == 0 and Config.wave_n > 0 and get_parent().get_node("Timer1").is_stopped():
		var tempPatha
		if Config.level == 1:
			tempPatha = path1a.instantiate()
		elif Config.level == 2:
			tempPatha = path2a.instantiate()
		add_child(tempPatha)
		
		if Config.wave == 3:
			var tempPathb
			if Config.level == 1:
				tempPathb = path1b.instantiate()
			elif Config.level == 2:
				tempPathb = path2b.instantiate()
			add_child(tempPathb)
		Config.wave_n -= 1
		
